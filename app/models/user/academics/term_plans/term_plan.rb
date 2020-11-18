class User::Academics::TermPlans::TermPlan
  attr_reader :data

  def initialize(data)
    @data = data || {}
  end

  def term_id
    data['term_id'].to_s
  end

  def academic_career_code
    data['acad_career']
  end

  def academic_career_description
    data['acad_career_descr']
  end

  def academic_program_code
    data['acad_program']
  end

  def academic_plan_code
    data['acad_plan']
  end

  def academic_career_role
    Concerns::AcademicRoles.get_academic_career_roles(academic_career_code.to_s).first
  end

  def academic_plan_roles
    Concerns::AcademicRoles.get_academic_plan_roles(academic_plan_code.to_s).uniq
  end

  def as_json(options={})
    {
      termId: term_id,
      academicCareerCode: academic_career_code,
      academicCareerDescription: academic_career_description,
      academicProgramCode: academic_program_code,
      academicPlanCode: academic_plan_code,
    }
  end
end
