FactoryBot.define do
  factory :user_academics_enrollment_date, class: User::Academics::Enrollment::Date do
    date_time { DateTime.parse('2020-04-13T12:30:00-07:00').utc.to_datetime }
  end
end
