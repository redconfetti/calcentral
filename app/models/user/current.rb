module User
  class Current
    attr_reader :uid

    include User::Academics::AcademicsConcern
    include User::Profile::ProfileConcern
    include User::BCourses::Concern
    include User::Notifications::Concern
    include User::Tasks::Concern
    include User::Webcasts::Concern

    def initialize(uid)
      @uid = uid
    end

    def self.from_campus_solutions_id(campus_solutions_id)
      uid = User::Identifiers.lookup_ldap_uid(campus_solutions_id)
      new(uid)
    end

    def campus_solutions_id
      @campus_solutions_id ||= User::Identifiers.lookup_campus_solutions_id(uid)
    end

    def aid_years
      @aid_years ||= User::FinancialAid::AidYears.new(self)
    end

    def award_comparison
      @award_comparison ||= User::FinancialAid::AwardComparison.new(self)
    end

    def award_comparison_for_aid_year_and_date(aid_year, effective_date)
      @award_comparison_data ||= User::FinancialAid::AwardComparisonData.new(self, aid_year, effective_date)
    end

    def billing_items
      @billing_items ||= User::Finances::BillingItems.new(self)
    end

    def billing_summary
      @billing_summary ||= User::Finances::BillingSummary.new(self)
    end

    def user_attributes
      @user_attributes ||= User::UserAttributes.new(self)
    end

    def student_attributes
      @student_attributes ||= User::Academics::StudentAttributes.new(self)
    end

    def term_registrations
      @term_registrations ||= User::Academics::TermRegistrations.new(self)
    end

    def status_and_holds
      @status_and_holds ||= User::Academics::StatusAndHolds.new(self)
    end

    def student_groups
      @student_groups ||= User::Academics::StudentGroups.new(self)
    end

    def matriculated?
      !affiliations.matriculated_but_exluded? && affiliations.not_registered?
    end

    def is_student?
      nil
    end

    private

    def affiliations
      @affiliations ||= User::Affiliations.new(self)
    end
  end
end
