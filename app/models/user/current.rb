module User
  class Current
    attr_reader :uid

    include User::Academics::AcademicsConcern
    include User::Finances::FinancesConcern
    include User::FinancialAid::FinancialAidConcern
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
  end
end
