# Serves 'Class Enrollment' card on 'My Academics' page
class Api::EnrollmentResources
  def initialize(user_id)
    @user = User::Current.new(user_id)
  end

  def enrollment_term_academic_planner
    {}
  end

  def enrollment_term_instruction_type_decks
    []
  end

  def enrollment_term_instructions
    {}
  end

  def enrollment_terms
    []
  end

  def enrollment_messages
    {}
  end

  def enrollment_links
    User::Academics::Enrollment::Links.new.links
  end

  def as_json(options={})
    {
      enrollmentTermAcademicPlanner: enrollment_term_academic_planner,
      enrollmentTermInstructionTypeDecks: enrollment_term_instruction_type_decks,
      enrollmentTermInstructions: enrollment_term_instructions,
      enrollmentTerms: enrollment_terms,
      links: enrollment_links,
      messages: enrollment_messages,
    }
  end
end
