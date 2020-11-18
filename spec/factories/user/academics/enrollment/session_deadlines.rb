# Usage:
#
# build(:user_academics_enrollment_session_deadline)
#
FactoryBot.define do
  factory :user_academics_enrollment_session_deadline, class: User::Academics::Enrollment::SessionDeadline do
    session { 'Regular Academic Session' }
    addDeadlineDatetime { '2021-02-10T23:59:00' }
    optionDeadlineDatetime { '2021-04-02T23:59:00' }

    initialize_with { new(attributes) }
  end
end
