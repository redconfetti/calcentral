# Usage:
#
# build(:user_academics_enrollment_advisor)
#
FactoryBot.define do
  factory :user_academics_enrollment_advisor, class: User::Academics::Enrollment::Advisor do
    sequence(:id) { |n| n.to_s }
    name { Faker::Name.name }
    emailAddress { Faker::Internet.email }
    program { 'Undergrad Letters & Science' }
    plan { 'Computer Science BA' }
    title { 'Instructor' }

    initialize_with { new(attributes) }
  end
end
