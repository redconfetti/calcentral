class Term
  attr_accessor :id, :type, :year, :code, :academic_career_code, :description
  attr_accessor :begin_date, :end_date, :class_begin_date, :class_end_date
  attr_accessor :instruction_end_date, :grades_entered_date, :end_drop_add_date
  attr_accessor :is_summer

  alias_attribute :term_id, :id

  def initialize(attrs={})
    attrs.each do |key, value|
      method = "#{key.to_s.underscore}="
      self.send(method, value) if respond_to?(method)
    end
  end

  def now
    Settings.terms.fake_now || Cache::CacheableDateTime.new(DateTime.now)
  end

  def name
    "#{semester_name} #{year}"
  end

  def summer?
    is_summer == 'Y'
  end

  def past?
    now > end_date
  end

  def active?
    !past?
  end

  def past_add_drop?
    end_drop_add_date ? now > end_drop_add_date : false
  end

  # Undergrad students are dropped on the first day of instruction.
  def past_classes_start?
    now > class_begin_date
  end

  # All term registration statuses are hidden the day after the term ends.
  def past_end_of_instruction?
    now > end_date
  end

  # Financial Aid disbursement is used in CNP notification.
  # This is defined as 9 days before the start of instruction.
  def past_financial_disbursement?
    now >= (begin_date - 9)
  end

  def past_grades_entered?
    now > grades_entered_date
  end

  def as_json(options={})
    {
      id: id,
      type: type,
      year: year,
      code: code,
      description: description,
      academic_career_code: academic_career_code,
      begin_date: begin_date,
      end_date: end_date,
      class_begin_date: class_begin_date,
      class_end_date: class_end_date,
      instruction_end_date: instruction_end_date,
      grades_entered_date: grades_entered_date,
      end_drop_add_date: end_drop_add_date,
      is_summer: summer?,
    }
  end
end
