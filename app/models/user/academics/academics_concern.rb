module User
  module Academics
    module AcademicsConcern
      extend ActiveSupport::Concern

      included do
        delegate :current_academic_roles, to: :academic_roles
        delegate :historic_academic_roles, to: :academic_roles

        def diploma
          @diploma ||= ::User::Academics::Diploma.new(self)
        end

        def enrollment_resources
          @enrollment_resources ||= ::User::Academics::Enrollment::Resources.new(self)
        end

        def holds
          @holds ||= ::User::Academics::Holds.new(self)
        end

        def has_holds?
          holds.any?
        end

        def registrations
          @registrations ||= ::User::Academics::Registrations.new(self)
        end

        def status_and_holds
          @status_and_holds ||= ::User::Academics::StatusAndHolds.new(self)
        end

        def student_attributes
          @student_attributes ||= ::User::Academics::StudentAttributes.new(self)
        end

        def student_groups
          @student_groups ||= ::User::Academics::StudentGroups.new(self)
        end

        def term_registrations
          @term_registrations ||= ::User::Academics::TermRegistrations.new(self)
        end

        def term_plans
          @term_plans ||= ::User::Academics::TermPlans::TermPlans.new(self)
        end

        def enrollment_terms
          @enrollment_terms ||= User::Academics::Enrollment::Terms.new(self)
        end

        def enrollment_term_plans
          @enrollment_term_plans ||= User::Academics::Enrollment::TermPlans.new(self)
        end

        def enrollment_term_instructions
          @enrollment_term_instructions ||= User::Academics::Enrollment::TermInstructions.new(self)
        end

        def enrollment_presentations
          @enrollment_presentations ||= User::Academics::Enrollment::Presentations.new(self)
        end

        def enrollment_messages
          @enrollment_messages ||= User::Academics::Enrollment::Messages.new
        end

        def enrollment_links
          @enrollment_links ||= User::Academics::Enrollment::Links.new(self)
        end

        private

        def academic_roles
          @academic_roles ||= ::User::Academics::Roles.new(self)
        end

      end
    end
  end
end
