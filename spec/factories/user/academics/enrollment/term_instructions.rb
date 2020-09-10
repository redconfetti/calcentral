FactoryBot.define do
  factory :user_academics_enrollment_term_instruction, class: User::Academics::Enrollment::TermInstruction do
    data { attributes_for(:user_academics_enrollment_term_instruction_data) }
  end

  factory :user_academics_enrollment_term_instruction_data, class: Hash do
    initialize_with { new(attributes) }

    studentId { '11667051' }
    term { '2208' }
    termDescr { 'Fall 2020' }
    advisors { [attributes_for(:user_academics_enrollment_advisor)] }
    isClassScheduleAvailable { true }
    isEndOfDropAddTimePeriod { false }
    enrollmentPeriod { [attributes_for(:user_academics_enrollment_term_instruction_enrollment_period_data)] }
    careers { [attributes_for(:user_academics_enrollment_career)] }
    scheduleOfClassesPeriod { attributes_for(:user_academics_enrollment_term_instruction_schedule_of_classes_period) }
    enrolledClasses { [attributes_for(:user_academics_enrollment_class, :enrollment)] }
    enrolledClassesTotalUnits { 0.0 }
    waitlistedClasses { [attributes_for(:user_academics_enrollment_class, :waitlist)] }
    waitlistedClassesTotalUnits { 0.0 }
  end

  factory :user_academics_enrollment_term_instruction_schedule_of_classes_period, class: Hash do
    initialize_with { new(attributes) }
    date { attributes_for(:user_academics_enrollment_term_instruction_date_data) }
  end

  factory :user_academics_enrollment_term_instruction_enrollment_period_data, class: Hash do
    initialize_with { new(attributes) }
    id { 'PRI1' }
    career { 'UGRD' }
    date { attributes_for(:user_academics_enrollment_term_instruction_date_data) }
    enddatetime { '2020-06-12T23:59:00' }
  end

  factory :user_academics_enrollment_term_instruction_date_data, class: Hash do
    initialize_with { new(attributes) }
    epoch { 1598943600 }
  end
end
