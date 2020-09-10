# Usage:
#
# build(:user_academics_enrollment_term_plan)
#
# Note: This class is a wrapper of User::Academics::TermPlans:TermPlan
# so it is best to rely on the trait variants defined for its factory
#
# build(:user_academics_enrollment_term_plan, {
#   term_plan: build(:user_academics_term_plans_term_plan, :fall_2020, :ugrd_fpf)
# })
#
FactoryBot.define do
  factory :user_academics_enrollment_term_plan, class: User::Academics::Enrollment::TermPlan do
    initialize_with { new(build(:user_academics_term_plans_term_plan)) }
  end
end
