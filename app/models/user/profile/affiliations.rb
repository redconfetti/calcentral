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

      def is_released_admit?
        ihub_affiliations.active_admit_affiliation_present?
      end

      def is_advisor?
        ihub_affiliations.active_advisor_affiliation_present?
      end

      def is_applicant?
        ihub_affiliations.active_applicant_affiliation_present?
      end

      def is_graduate?
        ihub_affiliations.active_graduate_affiliation_present?
      end

      def is_law_student?
        ihub_affiliations.active_law_affiliation_present?
      end

      def is_pre_sir?
        ihub_affiliations.active_pre_sir_affiliation_present?
      end

      def is_student?
        ihub_affiliations.active_student_affiliation_present?
      end

      def is_ex_student?
        ihub_affiliations.inactive_student_affiliation_present?
      end

      def is_uc_extension_student?
        ihub_affiliations.active_uc_extension_affiliation_present?
      end

      def is_undergraduate?
        ihub_affiliations.active_undergraduate_affiliation_present?
      end

      def ihub_affiliations
        ihub_person.affiliations
      end

      private

      def ihub_person
        @ihub_person ||= HubEdos::PersonApi::V1::Person.get(user)
      end

      def ldap_person
        @ldap_person ||= CalnetLdap::Person.get(user)
      end
    end
  end
end
