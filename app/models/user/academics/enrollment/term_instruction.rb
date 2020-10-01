class User::Academics::Enrollment::TermInstruction
  attr_reader :user
  attr_reader :term_id

  def initialize(user, term_id)
    @user = user
    @term_id = term_id
  end

  def enrollment_periods
    @enrollment_periods ||= ::User::Academics::Enrollment::Periods.new(fetch_attr(:enrollmentPeriod, []))
  end

  def enrollment_careers
    puts "fetch_attr(:careers, []): #{fetch_attr(:careers, []).inspect}"
    @enrollment_careers ||= ::User::Academics::Enrollment::Careers.new(fetch_attr(:careers, []))
  end

  def enrolled_classes
    @enrolled_classes ||= ::User::Academics::Enrollment::EnrollmentClasses.new(fetch_attr(:enrolledClasses, []), :enrollment)
  end

  def waitlisted_classes
    @waitlisted_classes ||= ::User::Academics::Enrollment::EnrollmentClasses.new(fetch_attr(:waitlistedClasses, []), :waitlist)
  end

  def as_json(options={})
    {
      user: user.uid,
      term_id: term_id,
      enrollmentPeriods: enrollment_periods.as_json,
      enrollmentCareers: enrollment_careers.as_json,
      enrolledClasses: enrolled_classes.as_json,
      waitlistedClasses: waitlisted_classes.as_json,
    }
  end

  private

  def fetch_attr(symbol, default)
    data[:enrollmentTerm][symbol] || default
  rescue NoMethodError
    default
  end

  def data
    @data ||= ::CampusSolutions::EnrollmentTerm.new({
      user_id: user.uid,
      term_id: term_id
    }).get[:feed]
    @data
  end
end
