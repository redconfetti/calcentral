module User
  module Profile
    # Affiliations Interface for Campus Solutions and LDAP Affiliation
    class Affiliations
      attr_reader :user

      def initialize(user)
        @user = user
      end

      def uid
        user.uid
      end

      def matriculated_but_excluded?
        ihub_affiliations.matriculated_but_excluded?
      end

      def not_registered?
        ldap_person.affiliations.include? 'STUDENT-TYPE-NOT REGISTERED'
      end

      def released_admit?
        ihub_affiliations.has_active_admit_affiliation?
      end

      def advisor?
        ihub_affiliations.has_active_advisor_affiliation?
      end

      def applicant?
        ihub_affiliations.has_active_applicant_affiliation?
      end

      def graduate?
        ihub_affiliations.has_active_graduate_affiliation?
      end

      def law_student?
        ihub_affiliations.has_active_law_affiliation?
      end

      def pre_sir?
        ihub_affiliations.has_active_pre_sir_affiliation?
      end

      def student?
        ihub_affiliations.has_active_student_affiliation?
      end

      def ex_student?
        ihub_affiliations.has_inactive_student_affiliation?
      end

      def uc_extension_student?
        ihub_affiliations.has_active_uc_extension_affiliation?
      end

      def undergraduate?
        ihub_affiliations.has_active_undergraduate_affiliation?
      end

      private

      def ihub_affiliations
        ihub_person.affiliations
      end

      def ihub_person
        @ihub_person ||= HubEdos::PersonApi::V1::Person.get(user)
      end

      def ldap_person
        @ldap_person ||= CalnetLdap::Person.get(user)
      end
    end
  end
end
