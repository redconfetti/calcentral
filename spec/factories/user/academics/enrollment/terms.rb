# Usage:
#
# build(:user_academics_enrollment_term, :ugrd, :fall_2020)
# build(:user_academics_enrollment_term, :grad, :spring_2021)
#
FactoryBot.define do
  factory :user_academics_enrollment_term, class: User::Academics::Enrollment::Term do
    user { build(:user) }
    term_id { '2212' }
    term_descr { '2021 Spring' }
    acad_career { 'UGRD' }

    trait :ugrd do
      acad_career { 'UGRD' }
    end

    trait :grad do
      acad_career { 'GRAD' }
    end

    trait :law do
      acad_career { 'LAW' }
    end

    trait :fall_2020 do
      term_id { '2208' }
      term_descr { '2020 Fall' }
    end

    trait :spring_2021 do
      term_id { '2212' }
      term_descr { '2021 Spring' }
    end
  end
end
