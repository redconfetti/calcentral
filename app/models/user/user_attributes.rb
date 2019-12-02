module User
  # Replacement for User::AggregatedAttributes
  class UserAttributes
    attr_reader :user

    def initialize(user)
      @user = user
    end

    def unknown?
      ldap_attributes.blank? && campus_solutions_id.blank?
    end

    def campus_solutions_id
      edo_attributes.try(:[], :campus_solutions_id)
    end

    def default_name
      get_campus_attribute('person_name', :string)
    end

    def first_name
      get_campus_attribute('first_name', :string) || ''
    end

    def given_first_name
      (edo_attributes && edo_attributes[:given_name]) || first_name || ''
    end

    def last_name
      get_campus_attribute('last_name', :string) || ''
    end

    def family_name
      (@edo_attributes && @edo_attributes[:family_name]) || last_name || ''
    end

    def student_id
      get_campus_attribute('student_id', :numeric_string)
    end

    def primary_email_address
      get_campus_attribute('email_address', :string)
    end

    def official_bmail_address
      get_campus_attribute('official_bmail_address', :string)
    end

    def edo_attributes
      return {} unless Settings.features.cs_profile
      @edo_attributes ||= HubEdos::UserAttributes.new(user_id: user.uid).get
    end

    def edo_roles
      edo_attributes.fetch(:roles) { Hash.new }
    end

    def ldap_attributes
      @ldap_attributes ||= CalnetLdap::UserAttributes.new(user_id: user.uid).get_feed
    end

    def ldap_roles
      ldap_attributes.fetch(:roles) { Hash.new }
    end

    def sis_profile_visible?
      Settings.features.cs_profile
    end

    def roles
      @roles ||= begin
        base_roles = Berkeley::UserRoles.base_roles
        campus_roles = base_roles.merge(ldap_roles)

        if sis_profile_visible?
          # Honor affiliations returned by both LDAP and CS
          # with exception of exStudent role (CS student role cancels out LDAP ex-student role)
          campus_roles.except!(:exStudent) if edo_roles[:student]
          campus_roles.merge(edo_roles) { |key, campus_role_value, edo_role_value| campus_role_value || edo_role_value }
        else
          campus_roles
        end
      end
    end

    def validate_attribute(value, format)
      case format
        when :string
          raise ArgumentError unless value.is_a?(String) && value.present?
        when :numeric_string
          raise ArgumentError unless value.is_a?(String) && Integer(value, 10)
      end
      value
    end

    def get_campus_attribute(field, format)
      # SIS is the source of record for student data
      # Prefer SIS attributes for students / applicants
      if sis_profile_visible? &&
        (roles[:student] || roles[:applicant]) &&
        edo_attributes[:noStudentId].blank? && (edo_field = edo_attributes[field.to_sym])
        begin
          validated_edo_field = validate_attribute(edo_field, format)
        rescue
          logger.error "EDO attribute #{field} failed validation for UID #{@uid}: expected a #{format}, got #{edo_field}"
        end
      end
      validated_edo_field || ldap_attributes[field.to_sym]
    end

    def as_json(options={})
      {
        ldapUid: user.uid,
        unknown: unknown?,
        sisProfileVisible: sis_profile_visible?,
        roles: roles,
        defaultName: default_name,
        firstName: first_name,
        lastName: last_name,
        givenFirstName: given_first_name,
        familyName: family_name,
        studentId: student_id,
        campusSolutionsId: campus_solutions_id,
        primaryEmailAddress: primary_email_address,
        officialBmailAddress: official_bmail_address,
      }
    end

  end
end
