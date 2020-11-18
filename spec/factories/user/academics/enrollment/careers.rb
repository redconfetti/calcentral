FactoryBot.define do
  factory :user_academics_enrollment_career, class: User::Academics::Enrollment::Career do
    acadCareer { 'UGRD' }
    termMaxUnits { '20.5' }
    sessionDeadlines { [attributes_for(:user_academics_enrollment_session_deadline)] }

    initialize_with { new(attributes) }
  end
end
