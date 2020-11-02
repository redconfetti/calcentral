module User
  class AggregatedAttributes < UserSpecificModel
    # TODO: Deprecate this in favor of User::UserAttributes
    include Cache::CachedFeed
    include Cache::UserCacheExpiry
    include CampusSolutions::ProfileFeatureFlagged

    def initialize(uid, options={})
      super(uid, options)
    end

    def get_feed_internal
      @edo_attributes = HubEdos::UserAttributes.new(user_id: @uid).get if is_cs_profile_feature_enabled
      @ldap_attributes = CalnetLdap::UserAttributes.new(user_id: @uid).get_feed
      campus_solutions_id = @edo_attributes[:campus_solutions_id] if @edo_attributes.present?
      unknown = @ldap_attributes.blank? && campus_solutions_id.blank?
      @sis_profile_visible = is_cs_profile_feature_enabled
      @roles = get_campus_roles
      first_name = get_campus_attribute('first_name', :string) || ''
      last_name = get_campus_attribute('last_name', :string) || ''
      {
        ldapUid: @uid,
        unknown: unknown,
        sisProfileVisible: @sis_profile_visible,
        roles: @roles,
        defaultName: get_campus_attribute('person_name', :string),
        firstName: first_name,
        lastName: last_name,
        givenFirstName: (@edo_attributes && @edo_attributes[:given_name]) || first_name || '',
        familyName: (@edo_attributes && @edo_attributes[:family_name]) || last_name || '',
        studentId: get_campus_attribute('student_id', :numeric_string),
        campusSolutionsId: campus_solutions_id,
        primaryEmailAddress: get_campus_attribute('email_address', :string),
        officialBmailAddress: get_campus_attribute('official_bmail_address', :string),
      }
    end

    private

    def get_campus_roles
      base_roles = Berkeley::UserRoles.base_roles
      ldap_roles = (@ldap_attributes && @ldap_attributes[:roles]) || {}
      campus_roles = base_roles.merge ldap_roles
      campus_roles[:withdrawnAdmit] = is_withdrawn_admit?
      if @sis_profile_visible
        edo_roles = (@edo_attributes && @edo_attributes[:roles]) || {}
        # Do not introduce conflicts if CS is more up-to-date on active student status.
        campus_roles.except!(:exStudent) if edo_roles[:student]
        # If there is a conflict between LDAP roles and EDO roles, keep the role as true
        campus_roles.merge(edo_roles) { |key, r1, r2| r1 || r2 }
      else
        campus_roles
      end
    end

    def is_withdrawn_admit?
      EdoOracle::Queries.is_withdrawn_admit?(@uid)
    end

    # Split brain three ways until some subset of the brain proves more trustworthy.
    def get_campus_attribute(field, format)
      if @sis_profile_visible &&
        (@roles[:student] || @roles[:applicant]) &&
        @edo_attributes[:noStudentId].blank? && (edo_attribute = @edo_attributes[field.to_sym])
        begin
          validated_edo_attribute = validate_attribute(edo_attribute, format)
        rescue
          logger.error "EDO attribute #{field} failed validation for UID #{@uid}: expected a #{format}, got #{edo_attribute}"
        end
      end
      validated_edo_attribute || @ldap_attributes[field.to_sym]
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

  end
end
