# Enrollment specific wrapper for User::Academics::TermPlans::TermPlan
class User::Academics::Enrollment::TermPlan
  attr_accessor :term_plan

  delegate  :term_id,
            :academic_career_code,
            :academic_career_role,
            :academic_program_code,
            :academic_plan_code,
            :academic_plan_roles,
            to: :term_plan

  DESIGN_ROLES = ['fpf', 'haasFullTimeMba', 'haasEveningWeekendMba', 'haasExecMba', 'summerVisitor', 'courseworkOnly', 'law', 'concurrent']

  def initialize(term_plan = nil)
    @term_plan = term_plan
  end

  # identifies the front-end enrollment card design that applies to this plan
  def design
    if academic_plan_roles.include? 'fpf'
      return 'fpf'
    elsif (DESIGN_ROLES & academic_plan_roles).any?
      return academic_plan_roles.first
    elsif DESIGN_ROLES.include? academic_career_role
      return academic_career_role
    end
    'default'
  end

  def inspect
    "#<#{self.class}:#{"0x00%x" % (object_id << 1)} #design='#{design}', @term_id='#{term_id}', @academic_career_code='#{academic_career_code}'>"
  end

  def as_json(options={})
    {
      design: design,
      termId: term_id,
      academicCareerCode: academic_career_code,
      academicProgramCode: academic_program_code,
      academicPlanCode: academic_plan_code,
    }
  end
end
