FactoryBot.define do
  factory :user_academics_enrollment_class, class: User::Academics::Enrollment::EnrollmentClass do
    type { :enrollment }

    trait :enrollment do
      type { :enrollment }
    end

    trait :waitlist do
      type { :waitlist }
    end

    id { '23150' }
    acadCareer { 'UGRD' }
    acadCareerDescr { 'Undergrad' }
    subjectCatalog { 'PHYSICS 8B' }
    title { 'INTRO PHYSICS' }
    ssrComponent { 'DIS' }
    ssrComponentDescr { 'Discussion' }
    add_attribute(:when) { ['Tu 12:00P-1:59P'] }
    units { 0.0 }
    edd { 'Y' }
  end
end
