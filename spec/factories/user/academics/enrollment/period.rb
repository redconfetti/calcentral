FactoryBot.define do
  factory :user_academics_enrollment_period, class: User::Academics::Enrollment::Period do
    id { 'PRI1' }
    name { 'Phase 1 Begins' }
    enddatetime { '2020-06-12T23:59:00' }
    date { attributes_for(:user_academics_enrollment_date_data) }
    acadCareer { 'UGRD' }
  end

  factory :user_academics_enrollment_date_data, class: Hash do
    epoch { 1586806200 }
    datetime { '2020-04-13T12:30:00-07:00' }
    datestring { '4/13' }
    offset { '-0700' }

    initialize_with { new(attributes) }
  end
end

