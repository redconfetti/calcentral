# Represents a specific enrollment term with a specific design that should
# be displayed to a student
class User::Academics::Enrollment::Presentation
  attr_accessor :user, :design, :term_id, :term_plans

  delegate :summer?, to: :term

  def initialize(user:, design:, term_id:, term_plans: [])
    @term_plans = term_plans
    @user = user
    @design = design
    @term_id = term_id
  end

  def academic_career_code
    term_plans.first.academic_career_code
  end

  def program_codes
    term_plans.collect {|tp| tp.academic_program_code }.uniq
  end

  def term_plans
    @selected_term_plan ||= @term_plans.select {|tp| tp.term_id == @term_id && tp.design == @design }
  end

  def semester_message
    User::Academics::Enrollment::SemesterMessage.new(term_id: term_id, academic_career_code: academic_career_code)
  end

  def class_info_message
    User::Academics::Enrollment::ClassInfoMessage.new(term_id: term_id, academic_career_code: academic_career_code)
  end

  def enrollment_career
    term_instruction.enrollment_careers.find_by_career_code(academic_career_code)
  end

  def as_json(options={})
    {
      design: design,
      termId: term_id,
      academicCareerCode: academic_career_code,
      programCodes: program_codes,
      termPlans: term_plans,
      semesterMessage: semester_message,
      classInfoMessage: class_info_message,
      constraints: enrollment_career,
      termIsSummer: summer?,
    }
  end

  private

  def term
    @term ||= ::Terms.find_undergraduate(term_id)
  end

  def term_instruction
    @term_instruction ||= user.enrollment_term_instructions.find_by_term_id(term_id)
  end
end
