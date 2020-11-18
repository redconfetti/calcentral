# Provides collection of presentation objects that indicate the enrollment
# card presentations that should be displayed. Intended to be grouped
# together by the front-end by 'design' with tabs displayed for each
# term within the specific designs group
class User::Academics::Enrollment::Presentations
  attr_accessor :user

  def initialize(user)
    @user = user
  end

  def all
    design_terms.collect do |design_term|
      presentation = User::Academics::Enrollment::Presentation.new(user: user, design: design_term[0], term_id: design_term[1])
      presentation.term_plans = applicable_term_plans
      presentation
    end
  end

  def as_json(options={})
    all.map(&:as_json)
  end

  private

  def design_terms
    applicable_term_plans.to_a.collect {|tp| [tp.design, tp.term_id] }.uniq
  end

  # returns term plans that intersect with active enrollment career terms
  def applicable_term_plans
    term_plans.select {|tp| career_term_pairs.include?([tp.term_id, tp.academic_career_code]) }
  end

  def term_plans
    @term_plans ||= user.enrollment_term_plans.current_and_future
  end

  def career_term_pairs
    @career_term_pairs ||= active_career_terms.collect {|ct| [ct.term_id, ct.acad_career] }.uniq
  end

  def active_career_terms
    @active_career_terms ||= user.enrollment_terms.all
  end
end
