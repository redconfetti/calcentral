# Usage:
#
# build(:user_academics_term_plans_term_plan, :spring_2021)
# build(:user_academics_term_plans_term_plan, :fall_2020, :ugrd_fpf)
#
FactoryBot.define do
  factory :user_academics_term_plans_term_plan, class: User::Academics::TermPlans::TermPlan do
    term_id { '2208' }
    acad_career { ::Careers::UNDERGRADUATE }
    acad_program { 'UCLS' }
    acad_plan { '25000U' }

    initialize_with { new(attributes.stringify_keys) }

    trait :fall_2020 do
      term_id { '2208' }
    end

    trait :spring_2021 do
      term_id { '2212' }
    end

    trait :grad_gacad do
      acad_career { ::Careers::GRADUATE }
      acad_program { 'GACAD' }
      acad_plan { '10153PHDG' }
    end

    trait :grad_uced do
      acad_career { ::Careers::GRADUATE }
      acad_program { 'UCED' }
      acad_plan { '19912U' }
    end

    trait :grad_haas_execmba do
      acad_career { ::Careers::GRADUATE }
      acad_program { 'GSSDP' }
      acad_plan { '70364MBAG' }
    end

    trait :law_lprfl do
      acad_career { ::Careers::LAW }
      acad_program { 'LPRFL' }
      acad_plan { '84501JDG' }
    end

    trait :ugrd_fpf do
      acad_plan { '25000FPFU' }
    end

    trait :ucbx_concurrent do
      acad_career { ::Careers::CONCURRENT }
      acad_program { 'XCCRT' }
      acad_plan { '30XCECCENX' }
    end

    trait :law do
      acad_career { 'LAW' }
      acad_program { 'LPRFL' }
      acad_plan { '84501JDG' }
    end

    trait :grad_haas_ewmba do
      acad_career { 'GRAD' }
      acad_program { 'GSSDP' }
      acad_plan { '701E1MBAG' }
    end

    trait :grad_haas_ewmba do
      acad_career { 'GRAD' }
      acad_program { 'GSSDP' }
      acad_plan { '701E1MBAG' }
    end

    trait :grad_summer_visitor do
      acad_career { 'GRAD' }
      acad_program { 'GNODG' }
      acad_plan { '99000G' }
    end

  end
end
