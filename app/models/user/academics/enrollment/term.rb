class User::Academics::Enrollment::Term
  attr_accessor :user

  attr_accessor :term_id
  attr_accessor :term_descr
  attr_accessor :acad_career

  def initialize(attrs={})
    attrs.each do |key, value|
      method = "#{key.to_s.underscore}="
      self.send(method, value) if respond_to?(method)
    end
  end

  def as_json(options={})
    {
      career: career_code,
      classInfoMessage: class_info_message,
      constraints: enrollment_career,
      enrollmentPeriods: enrollment_periods,
      message: enrollment_message,
      programCode: term_plan&.academic_program_code,
      requiresCalgrantAcknowledgement: requires_cal_grant_acknowledgement?,
      summer: summer?,
      termId: term_id,
    }
  end

  def requires_cal_grant_acknowledgement?
    student_attributes
      .find_by_term_id(term_id)
      .any?(&:requires_cal_grant_acknowledgement?)
  end

  def class_info_message
    ::User::Academics::Enrollment::ClassInfoMessage.new({
      career_code: career_code,
      semester_name: semester_name
    })
  end

  def enrollment_message
    ::User::Academics::Enrollment::Message.new({
      career_code: career_code,
      semester_name: semester_name
    })
  end

  private

  delegate :semester_name, :summer?, to: :term

  def term
    puts "term_id: #{term_id.inspect}"
    @term ||= ::Terms.find_undergraduate(term_id)
  end

  def term_plan
    term_plans.find_by_term_id_and_career_code(term_id, career_code)
  end

  def career_code
    acad_career.downcase
  end

  def term_instruction
    @term_instruction ||= begin
      term_instructions = ::User::Academics::Enrollment::TermInstructions.new(user)
      term_instructions.find_by_term_id(term_id)
    end
  end

  def enrollment_periods
    @enrollment_periods ||= term_instruction.enrollment_periods.for_career(career_code)
  end

  def enrollment_career
    @enrollment_career ||= term_instruction.enrollment_careers.find_by_career_code(career_code)
  end

  def student_attributes
    user.student_attributes
  end

  def term_plans
    user.term_plans
  end
end
