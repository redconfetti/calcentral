# Serves 'Class Enrollment' card on 'My Academics' page
class Api::EnrollmentResources
  def initialize(user_id)
    @user = User::Current.new(user_id)
  end

  def enrollment_term_academic_planner
    # Asking Marty if we can just move this to the CS Link API
    #
    # [2020-10-30 14:45:09] [INFO] [CampusSolutions::AcademicPlan]
    # Fake = false; Making request to https://bcsdev.is.berkeley.edu/PSIGW/RESTListeningConnector/PSFT_CS/UC_SR_ACADEMIC_PLANNER.v1/get?EMPLID=11667051&STRM=2208
    # on behalf of user 61889, campus_solutions_id = 11667051; cache expiration 2100
    # academic_plan = CampusSolutions::AcademicPlan.new(user_id: uid, term_id: term_id).get
    # {
    #   :statusCode=>200,
    #   :feed=>{
    #     :studentId=>"11667051",
    #     :updateAcademicPlanner=>{
    #       :name=>"Update",
    #       :url=>"https://bcsdev.is.berkeley.edu/psp/bcsdev/EMPLOYEE/SA/c/SCI_PLNR_FL.SCI_PLNR_FL.GBL?ucInstitution=UCB01",
    #       :isCsLink=>true
    #     },
    #     :academicplanner=>[
    #       {:term=>"2208", :termDescr=>"2020 Fall"}
    #     ]
    #   }
    # }
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
