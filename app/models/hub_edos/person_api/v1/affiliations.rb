module HubEdos
  module PersonApi
    module V1
      class Affiliations
        attr_reader :data

        def initialize(data = [])
          @data = data
        end

        def active
          all.select(&:active?)
        end

        def inactive
          all.select(&:inactive?)
        end

        def has_active_admit_affiliation?
          active_type_present?(:admit_ux?)
        end

        def has_active_advisor_affiliation?
          active_type_present?(:advisor?)
        end

        def has_active_applicant_affiliation?
          active_type_present?(:applicant?)
        end

        def has_active_law_affiliation?
          active_type_present?(:law?)
        end

        def has_active_graduate_affiliation?
          active_type_present?(:graduate?)
        end

        def has_active_pre_sir_affiliation?
          active_type_present?(:pre_sir?)
        end

        def has_active_student_affiliation?
          active_type_present?(:student?)
        end

        def has_active_uc_extension_affiliation?
          active_type_present?(:uc_extension?)
        end

        def has_active_undergraduate_affiliation?
          active_type_present?(:undergraduate?)
        end

        def has_inactive_student_affiliation?
          found_affiliation = inactive.find do |affiliation|
            affiliation.student? ||
            affiliation.graduate? ||
            affiliation.undergraduate?
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
