module EdoOracle
  module UserCourses
    class Base < BaseProxy
      include Cache::UserCacheExpiry

      attr_reader :uid

      def self.expire(id = nil)
        super(id)
        super("summary-#{id}")
      end

      def self.access_granted?(uid)
        !uid.blank?
      end

      def initialize(options = {})
        super(Settings.edodb, options)
        @uid = @settings.fake_user_id if @fake
        @academic_terms = Berkeley::Terms.fetch.campus.values
      end

      def get_all_campus_courses
        # Because this data structure is used by multiple top-level feeds, it's essential
        # that it be cached efficiently.
        self.class.fetch_from_cache @uid do
          campus_classes = {}
          merge_instructing campus_classes
          merge_enrollments campus_classes
          sort_courses campus_classes

          # Sort the hash in descending order of semester.
          campus_classes = Hash[campus_classes.sort.reverse]

          # Merge each section's schedule, location, and instructor list.
          # TODO Is this information useful for non-current terms?
          merge_detailed_section_data(campus_classes)

          campus_classes
        end
      end

      def get_enrollments_summary
        self.class.fetch_from_cache "summary-#{@uid}" do
          campus_classes = {}
          merge_enrollments campus_classes
          sort_courses campus_classes
          campus_classes = Hash[campus_classes.sort.reverse]
          remove_duplicate_sections(campus_classes)
          campus_classes
        end
      end

      def merge_enrollments(campus_classes)
        return if @academic_terms.empty?
        previous_item = {}

        EdoOracle::Queries.get_enrolled_sections(@uid, @academic_terms).each do |row|
          if (item = row_to_feed_item(row, previous_item))
            item[:role] = 'Student'
            # Cross-listed courses may lack descriptive names. Students, unlike instructors, will
            # not get the correctly named course elsewhere in their feed.
            merge_cross_listed_titles item
            merge_feed_item(item, campus_classes)
            previous_item = item
          end
        end
      end

      def merge_instructing(campus_classes)
        return if @academic_terms.empty?
        previous_item = {}
        cross_listing_tracker = {}

        EdoOracle::Queries.get_instructing_sections(@uid, @academic_terms).each do |row|
          if (item = row_to_feed_item(row, previous_item, cross_listing_tracker))
            item[:role] = 'Instructor'
            merge_feed_item(item, campus_classes)
            previous_item = item
          end
        end
        merge_implicit_instructing campus_classes
      end

      # This is done in a separate step so that all secondary sections
      # are ordered after explicitly assigned primary sections.
      def merge_implicit_instructing(campus_classes)
        campus_classes.each_value do |term|
          term.each do |course|
            if course[:role] == 'Instructor'
              section_ids = course[:sections].map { |section| section[:ccn] }.to_set
              course[:sections].select { |section| section[:is_primary_section] }.each do |primary|
                EdoOracle::Queries.get_associated_secondary_sections(course[:term_id], primary[:ccn]).each do |row|
                  # Skip duplicates.
                  if section_ids.add? row['section_id']
                    course[:sections] << row_to_section_data(row)
                  end
                end
              end
            end
          end
        end
      end

      def merge_feed_item(item, campus_classes)
        semester_key = item.values_at(:term_yr, :term_cd).join '-'
        campus_classes[semester_key] ||= []
        campus_classes[semester_key] << item
      end

      def row_to_feed_item(row, previous_item, cross_listing_tracker=nil)
        class_enrollment = class_from_row row
        if class_enrollment[:id] == previous_item[:id] && previous_item[:session_code] == Berkeley::TermCodes::SUMMER_SESSIONS[row['session_id']]
          previous_section = previous_item[:sections].last
          # Odd database joins will occasionally give us null course titles, which we can replace from later rows.
          previous_item[:name] = row['course_title'] if previous_item[:name].blank?
          # Duplicate CCNs indicate duplicate section listings. The only possibly useful information in these repeated
          # listings is a more relevant associated-primary ID for secondary sections.
          if (row['section_id'].to_s == previous_section[:ccn]) && !to_boolean(row['primary'])
            primary_ids = previous_item[:sections].map{ |sec| sec[:ccn] if sec[:is_primary_section] }.compact
            if !primary_ids.include?(previous_section[:associated_primary_id]) && primary_ids.include?(row['primary_associated_section_id'])
              previous_section[:associated_primary_id] = row['primary_associated_section_id']
            end
          else
            previous_item[:sections] << row_to_section_data(row, cross_listing_tracker)
            sum_primary_limits(previous_item, row) unless row['enroll_status']
          end
          nil
        else
          term_data = Berkeley::TermCodes.from_edo_id(row['term_id']).merge({
            term_id: row['term_id'],
            session_code: Berkeley::TermCodes::SUMMER_SESSIONS[row['session_id']]
          })
          course_name = row['course_title'].present? ? row['course_title'] : row['course_title_short']
          course_data = {
            emitter: 'Campus',
            name: course_name,
            sections: [
              row_to_section_data(row, cross_listing_tracker)
            ]
          }
          sum_primary_limits(course_data, row) unless row['enroll_status']
          class_enrollment.merge(term_data).merge(course_data)
        end
      end

      def sort_courses(campus_classes)
        campus_classes.each_value do |semester_classes|
          semester_classes.sort_by! { |c| Berkeley::CourseCodes.comparable_course_code c }
        end
      end

      def sum_primary_limits(course_data, row)
        return unless to_boolean(row['primary'])
        course_data[:enroll_limit] ||= 0
        course_data[:waitlist_limit] ||= 0
        course_data[:enroll_limit] += row['enroll_limit'].to_i
        course_data[:waitlist_limit] += row['waitlist_limit'].to_i
      end

      # Create IDs for a given course item:
      #   "id" : unique for the UserCourses feed across terms; used by Classes
      #   "slug" : URL-friendly ID without term information; used by Academics
      #   "course_code" : the short course name as displayed in the UX
      def class_from_row(row)
        dept_name, dept_code, catalog_id = parse_course_code row
        slug = [dept_code, catalog_id].map { |str| normalize_to_slug str }.join '-'
        term_code = Berkeley::TermCodes.edo_id_to_code row['term_id']
        session_code = Berkeley::TermCodes::SUMMER_SESSIONS[row['session_id']]
        course_id =  session_code.present? ? "#{slug}-#{term_code}-#{session_code}" : "#{slug}-#{term_code}"
        {
          catid: catalog_id,
          course_catalog: catalog_id,
          course_code: "#{dept_code} #{catalog_id}",
          dept: dept_name,
          dept_code: dept_code,
          id: course_id,
          slug: slug,
          academicCareer: row['acad_career'],
          courseCareerCode: row['course_career_code'],
          requirementsDesignationCode: row['rqmnt_designtn'],
          cs_course_id: row['cs_course_id']
        }
      end

      def normalize_to_slug(str)
        str.downcase.gsub(/[^a-z0-9-]+/, '_')
      end

      def row_to_section_data(row, cross_listing_tracker=nil)
        section_data = ::EdoOracle::UserCourses::Section.new(user, row).as_json

        # Cross-listed primaries are tracked only when merging instructed sections.
        if cross_listing_tracker && section_data[:is_primary_section]
          cross_listing_slug = row.values_at('term_id', 'cs_course_id', 'instruction_format', 'section_num').join '-'
          if (cross_listings = cross_listing_tracker[cross_listing_slug])
            # The front end expects cross-listed primaries to share a unique identifier, called 'hash'
            # because it was formerly implemented as an Oracle hash.
            section_data[:cross_listing_hash] = cross_listing_slug
            if cross_listings.length == 1
              cross_listings.first[:cross_listing_hash] = cross_listing_slug
            end
            cross_listings << section_data
          else
            cross_listing_tracker[cross_listing_slug] = ([] << section_data)
          end
        end

        section_data
      end

      def remove_duplicate_sections(campus_classes)
        campus_classes.each_value do |semester|
          semester.each do |course|
            course[:sections].uniq!
          end
        end
      end

      def merge_cross_listed_titles(course)
        if (course[:catid].start_with? 'C') && !course[:name]
          title_results = self.class.fetch_from_cache "cross_listed_title-#{course[:course_code]}" do
            EdoOracle::Queries.get_cross_listed_course_title course[:course_code]
          end
          if title_results.present?
            course[:name] = title_results['course_title'] || title_results['course_title_short']
          end
        end
      end

      def merge_detailed_section_data(campus_classes)
        # Track instructors as we go to allow an efficient final overwrite with directory attributes.
        instructors_by_uid = {}
        campus_classes.each_value do |semester|
          semester.each do |course|
            course[:sections].uniq!
            course[:sections].each do |section|
              section_data = EdoOracle::CourseSections.new(course[:term_id], section[:ccn]).get_section_data
              section_data[:instructors].each do |instructor_data|
                instructors_by_uid[instructor_data[:uid]] ||= []
                instructors_by_uid[instructor_data[:uid]] << instructor_data
              end
              section.merge! section_data
            end
          end
        end
        User::BasicAttributes.attributes_for_uids(instructors_by_uid.keys).each do |instructor_attributes|
          if (instructor_entries = instructors_by_uid[instructor_attributes[:ldap_uid]])
            instructor_entries.each { |entry| entry[:name] = instructor_attributes.values_at(:first_name, :last_name).join(' ') }
          end
        end
      end

      def to_boolean(string)
        string.try(:downcase) == 'true'
      end

      # Our underlying database join between sections and courses is shaky, so we need a series of fallbacks.
      def parse_course_code(row)
        subject_area, class_subject_area, catalog_number = row.values_at('dept_name', 'dept_code', 'catalog_id')
        unless subject_area && catalog_number
          display_name = row['course_display_name'] || row['section_display_name']
          subject_area, catalog_number = display_name.rpartition(/\s+/).reject &:blank?
        end
        @subject_areas ||= EdoOracle::SubjectAreas.fetch
        subject_area = @subject_areas.decompress subject_area
        [subject_area, class_subject_area, catalog_number]
      end

      private

      def user
        @user ||= ::User::Current.new(uid)
      end
    end
  end
end
