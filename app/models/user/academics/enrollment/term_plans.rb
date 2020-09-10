# Enrollment specific wrapper for User::Academics::TermPlans::TermPlans
class User::Academics::Enrollment::TermPlans
  def initialize(user)
    @user = user
  end

  def current_and_future
    current_and_future_plans.collect {|plan| User::Academics::Enrollment::TermPlan.new(plan) }
  end

  private

  def current_and_future_plans
    @current_and_future_plans ||= User::Academics::TermPlans::TermPlans.new(@user).current_and_future
  end
end
