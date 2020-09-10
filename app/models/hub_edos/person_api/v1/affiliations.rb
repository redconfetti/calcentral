module HubEdos
  module PersonApi
    module V1
      class Affiliations
        attr_reader :data

        def initialize(data = [])
          @data = data
        end

        def active
          all.select(&:is_active?)
        end

        def inactive
          all.select(&:is_inactive?)
        end

        def active_admit_affiliation_present?
          active_type_present?(:is_admit_ux?)
        end

        def active_advisor_affiliation_present?
          active_type_present?(:is_advisor?)
        end

        def active_applicant_affiliation_present?
          active_type_present?(:is_applicant?)
        end

        def active_law_affiliation_present?
          active_type_present?(:is_law?)
        end

        def active_graduate_affiliation_present?
          active_type_present?(:is_graduate?)
        end

        def active_pre_sir_affiliation_present?
          active_type_present?(:is_pre_sir?)
        end

        def active_student_affiliation_present?
          active_type_present?(:is_student?)
        end

        def active_uc_extension_affiliation_present?
          active_type_present?(:is_uc_extension?)
        end

        def active_undergraduate_affiliation_present?
          active_type_present?(:is_undergraduate?)
        end

        def inactive_student_affiliation_present?
          found_affiliation = inactive.find do |affiliation|
            affiliation.is_student? ||
            affiliation.is_graduate? ||
            affiliation.is_undergraduate?
          end.present?
        end

        def all
          @all ||= data.collect do |affiliation_data|
            ::HubEdos::PersonApi::V1::Affiliation.new(affiliation_data)
          end
        end

        def matriculated_but_excluded?
          all.find(&:matriculated_but_excluded?).present?
        end

        private

        def active_type_present?(sym)
          active.find(&sym).present?
        end

      end
    end
  end
end
