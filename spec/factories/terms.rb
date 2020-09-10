# Usage:
#
# term = build(:term)
# term = build(:term, :undergraduate)
# term = build(:term, :graduate)
#
FactoryBot.define do
  factory :term, class: ::Term do
    id { '2208' }
    description { 'Fall 2020' }
    type { 'Fall' }
    year { '2020' }
    code { 'D' }
    academic_career_code { ::Careers::UNDERGRADUATE }
    begin_date { Time.parse('2020-08-19 00:00:00 UTC') }
    end_date { Time.parse('2020-12-18 00:00:00 UTC') }
    class_begin_date { Time.parse('2020-08-26 00:00:00 UTC') }
    class_end_date { Time.parse('2020-12-11 00:00:00 UTC') }
    instruction_end_date { Time.parse('2020-12-11 00:00:00 UTC') }
    end_drop_add_date { Time.parse('2020-09-16 00:00:00 UTC') }
    grades_entered_date { Time.parse('2020-12-27 00:00:00 UTC') }
    is_summer { 'N' }

    trait :undergraduate do
      academic_career_code { ::Careers::UNDERGRADUATE }
    end

    trait :graduate do
      academic_career_code { ::Careers::GRADUATE }
    end

    factory :spring_2021_term do
      id { '2212' }
      description { 'Spring 2021' }
      type { 'Spring' }
      year { '2021' }
      code { 'B' }
      begin_date { Time.parse('2021-01-12T00:00:00.000Z') }
      end_date { Time.parse('2021-05-14T00:00:00.000Z') }
      class_begin_date { Time.parse('2021-01-19T00:00:00.000Z') }
      class_end_date { Time.parse('2021-05-07T00:00:00.000Z') }
      instruction_end_date { Time.parse('2021-05-07T00:00:00.000Z') }
      end_drop_add_date { Time.parse('2021-02-10T00:00:00.000Z') }
      grades_entered_date { Time.parse('2020-05-22 00:00:00 UTC') }
    end

    factory :summer_2021_term do
      id { '2215' }
      description { 'Summer 2021' }
      type { 'Summer' }
      year { '2021' }
      code { 'C' }
      begin_date { Time.parse('2021-05-24T00:00:00.000Z') }
      end_date { Time.parse('2021-08-13T00:00:00.000Z') }
      class_begin_date { Time.parse('2020-05-28T00:00:00.000Z') }
      class_end_date { nil }
      instruction_end_date { nil }
      end_drop_add_date { Time.parse('2020-06-15T00:00:00.000Z') }
      grades_entered_date { nil }
      end_drop_add_date { Time.parse('2020-06-15 00:00:00 UTC') }
      is_summer { 'Y' }
    end

    factory :fall_2021_term do
      id { '2218' }
      description { 'Fall 2021' }
      type { 'Fall' }
      year { '2021' }
      code { 'D' }
      begin_date { Time.parse('2021-08-18T00:00:00.000Z') }
      end_date { Time.parse('2021-12-17T00:00:00.000Z') }
      class_begin_date { Time.parse('2021-08-25T00:00:00.000Z') }
      class_end_date { Time.parse('2021-12-10T00:00:00.000Z') }
      instruction_end_date { Time.parse('2021-12-10T00:00:00.000Z') }
      grades_entered_date { Time.parse('2020-12-27 00:00:00 UTC') }
      end_drop_add_date { Time.parse('2021-09-15T00:00:00.000Z') }
      is_summer { 'N' }
    end
  end
end
