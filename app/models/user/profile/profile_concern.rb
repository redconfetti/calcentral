module User
  module Profile
    module ProfileConcern
      extend ActiveSupport::Concern

      included do
        delegate :advisor?, to: :affiliations
        delegate :applicant?, to: :affiliations
        delegate :graduate?, to: :affiliations
        delegate :law_student?, to: :affiliations
        delegate :pre_sir?, to: :affiliations
        delegate :released_admit?, to: :affiliations
        delegate :student?, to: :affiliations
        delegate :uc_extension_student?, to: :affiliations
        delegate :undergraduate?, to: :affiliations
        delegate :ex_student?, to: :affiliations

        delegate :unreleased_applicant?, to: :roles

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
