module Berkeley
  class Term
    include ActiveAttrModel, ClassLogger
    include Comparable
    extend Cache::Cacheable

    # Legacy SIS term code, only used for integration with legacy DB sources.
    attr_reader :code
    # CS term ID.
    attr_reader :campus_solutions_id
    attr_reader :name
    attr_reader :slug
    attr_reader :year
    # The Academic Calendar shows Fall/Spring semesters beginning one week before classes.
    attr_reader :start
    # The Fall/Spring semesters end two weeks after the end of formal classes.
    attr_reader :end
    # The first day of instruction.  This date is used for Cancellation for Non-Payment logic to trigger the change from a
    # CNP notification to a CNP warning, as well as the drop date for undergraduates.
    attr_reader :classes_start
    attr_reader :classes_end
    # The end of instruction is one week after classes end. The week between is RRR week. The week after is for final exams.
    attr_reader :instruction_end
    # The end of the drop/add period, used for Cancellation for Non-Payment as the drop date for Grad and Law students.
    attr_reader :end_drop_add
    # BearFacts and related systems set "CT"/"Current Term" to Fall (and "FT"/"Future Term" to
    # the next year's Spring) as soon as the Spring term is over. Summer terms are special-cased as
    # "CS" or "FS", and lack some SIS support. This quirk becomes important when configuring
    # certain queries, notably Tele-BEARS appointments.
    attr_reader :legacy_sis_term_status
    # returns true for the Summer term, false otherwise
    attr_reader :is_summer
    # The raw data source.
    attr_reader :raw_source

    FALL_2016_DATES = {
      'term_start_date' => Time.parse('2016-08-24 00:00:00 UTC'),
      'term_end_date' => Time.parse('2016-12-09 00:00:00 UTC')
    }

    def initialize(db_row = nil)
      from_legacy_db(db_row) if db_row.present?
    end

    def from_json_file(term)
      @campus_solutions_id = term['campus_solutions_id']
      @year = term['year'].to_i
      @slug = term['slug']
      @name = term['name']
      @start = term['start'].to_date.in_time_zone.to_datetime
      @end = term['end'].to_date.in_time_zone.to_datetime
      (_, @code) = TermCodes.from_edo_id(@campus_solutions_id).values
      if @code == 'C'
        @is_summer = true
        @classes_start = @start
        @classes_end = @end
        @instruction_end = @end
        @end_drop_add = false
      else
        @is_summer = false
        @classes_start = term['classes_start'].to_date.in_time_zone.to_datetime
        @instruction_end = term['instruction_end'].to_date.in_time_zone.to_datetime
        @classes_end = term['classes_end'].to_date.in_time_zone.to_datetime
        @end_drop_add =term['end_drop_add'] if term['end_drop_add'].present?
      end
      self
    end

    def from_edo_db(db_row)
      @campus_solutions_id = db_row['term_id']
      @code = db_row['term_code'].to_s
      @year = db_row['term_year'].to_i
      @slug = TermCodes.to_slug(@year, @code)
      @name = db_row['term_type']
      @start = db_row['term_begin_date'].to_date.in_time_zone.to_datetime
      @end = db_row['term_end_date'].to_date.in_time_zone.to_datetime
      if @code == 'C'
        @is_summer = true
        @classes_start = @start
        @classes_end = @end
        @instruction_end = @end
        @end_drop_add = false
      else
        @is_summer = false
        @classes_start = db_row['class_begin_date'].to_date.in_time_zone.to_datetime if db_row['class_begin_date'].present?
        @instruction_end = db_row['instruction_end_date'].to_date.in_time_zone.to_datetime if db_row['instruction_end_date'].present?
        @classes_end = db_row['class_end_date'].to_date.in_time_zone.to_datetime if db_row['class_end_date'].present?
        @end_drop_add =db_row['end_drop_add_date'] if db_row['end_drop_add_date'].present?
      end
      self
    end

    def from_legacy_db(db_row)
      term_cd = db_row['term_cd']
      term_yr = db_row['term_yr'].to_i
      @code = term_cd
      @year = term_yr
      @name = db_row['term_name']
      @slug = TermCodes.to_slug(term_yr, term_cd)
      @campus_solutions_id = TermCodes.to_edo_id(term_yr, term_cd)

      # TODO Remove this embarrassment as soon as we switch to Campus Solutions for source of record on term dates.
      db_row.merge! FALL_2016_DATES if @slug == 'fall-2016'

      @classes_start = db_row['term_start_date'].to_date.in_time_zone.to_datetime
      @instruction_end = db_row['term_end_date'].to_date.in_time_zone.to_datetime.end_of_day
      @legacy_sis_term_status = db_row['term_status']
      if term_cd == 'C'
        @start = @classes_start
        @end = @instruction_end
        @classes_end = @instruction_end
        @is_summer = true
      else
        @start = @classes_start.advance(days: -7)
        @end = @instruction_end.advance(days: 7)
        @classes_end = @instruction_end.advance(days: -7)
        @is_summer = false
      end
      self
    end

    def to_english
      TermCodes.to_english(year, code)
    end

    def <=>(other_term)
      campus_solutions_id <=> other_term.campus_solutions_id
    end

    def legacy?
      TermCodes.legacy?(@year, @code)
    end

    # Most final grades should appear on the transcript by this date.
    def grades_entered
      @end.advance(weeks: 4)
    end

    def to_h
      methods = [:campus_solutions_id, :name, :year, :code, :slug, :to_english,
        :start, :end, :classes_start, :classes_end, :instruction_end, :grades_entered,
        :is_summer, :legacy?, :end_drop_add]
      Hash[methods.collect {|m| [m, send(m)]}]
    end

    def to_s
      "#<Berkeley::Term> #{to_h}"
    end
  end
end
