class User::Academics::TermPlans::TermPlansCached < UserSpecificModel
  include Cache::CachedFeed
  include Cache::UserCacheExpiry

  attr_reader :user, :uid

  def initialize(user)
    @user = user
    @uid = user.uid
  end

  def get_feed_internal
    ::User::Academics::TermPlans::Queries.get_student_term_cpp(user.campus_solutions_id)
  end
end
