module MyClasses
  class Canvas
    include ClassesModule

    def merge_sites(campus_courses, term, sites)
      return unless ::Canvas::Proxy.access_granted?(@uid)
      if (canvas_sites = ::Canvas::MergedUserSites.new(@uid).get_feed)
        included_course_sites = {}
        canvas_sites[:courses].each do |course_site|
          if (entry = course_site_entry(campus_courses, course_site, term))
            sites << entry
            included_course_sites[entry[:id]] = {
              source: entry[:name],
              courses: entry[:courses]
            }
          end
        end
        canvas_sites[:groups].each do |group_site|
          if (entry = group_site_entry(included_course_sites, group_site))
            sites << entry
          end
        end
      end
    end

    def group_site_entry(included_course_sites, group_site)
      if (linked_id = group_site[:course_id]) && (linked_entry = included_course_sites[linked_id])
        {
          emitter: group_site[:emitter],
          id: group_site[:id],
          name: group_site[:name],
          siteType: 'group',
          site_url: group_site[:site_url]
        }.merge(linked_entry)
      else
        nil
      end
    end

    def course_site_entry(campus_courses, course_site, term)
      return unless matches_term?(course_site, term)
      linked_campus_courses = []
      if (sections = course_site[:sections])
        candidate_ccns = sections.collect {|s| s[:ccn].to_i}
        campus_courses.each do |campus_course|
          if matches_term?(campus_course, term) && campus_course[:sections].find {|s| candidate_ccns.include?(s[:ccn].to_i)}
            linked_campus_courses << {id: campus_course[:listings].first[:id]}
          end
        end
      end
      course_site.slice(:emitter, :id, :name, :shortDescription, :site_url, :term_cd, :term_yr).merge({
        siteType: 'course',
        courses: linked_campus_courses.uniq
      })
    end

    private

    def matches_term?(course, term)
      term && term.year == course[:term_yr].to_i && term.code == course[:term_cd]
    end
  end
end
