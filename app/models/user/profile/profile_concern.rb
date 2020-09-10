module User
  module Profile
    module ProfileConcern
      extend ActiveSupport::Concern

      included do
        delegate :is_advisor?, to: :affiliations
        delegate :is_applicant?, to: :affiliations
        delegate :is_graduate?, to: :affiliations
        delegate :is_law_student?, to: :affiliations
        delegate :is_pre_sir?, to: :affiliations
        delegate :is_released_admit?, to: :affiliations
        delegate :is_student?, to: :affiliations
        delegate :is_uc_extension_student?, to: :affiliations
        delegate :is_undergraduate?, to: :affiliations
        delegate :is_ex_student?, to: :affiliations

        delegate :is_unreleased_applicant?, to: :roles

        def matriculated?
          !affiliations.matriculated_but_excluded? && affiliations.not_registered?
        end

        private

        def roles
          @roles ||= ::User::Profile::Roles.new(self)
        end

        def affiliations
          @affiliations ||= ::User::Profile::Affiliations.new(self)
        end
      end

    end
  end
end
