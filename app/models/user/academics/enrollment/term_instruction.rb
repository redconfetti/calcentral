class User::Academics::Enrollment::TermInstruction
  attr_reader :user
  attr_reader :term_id

  def initialize(user, term_id)
    @user = user
    @term_id = term_id
  end

  def class_schedule_available?
    fetch_attr(:isClassScheduleAvailable, nil)
  end

  def end_of_drop_add_time_period?
    fetch_attr(:isEndOfDropAddTimePeriod, nil)
  end

  def term_description
    fetch_attr(:termDescr, nil)
  end

  def schedule_of_classes_period
    date = fetch_attr(:scheduleOfClassesPeriod, nil)[:date]
    User::Academics::Enrollment::Date.new(date)
  end

  def advisors
    @advisors ||= ::User::Academics::Enrollment::Advisors.new(fetch_attr(:advisors, []))
  end

  def enrollment_periods
    @enrollment_periods ||= ::User::Academics::Enrollment::Periods.new(fetch_attr(:enrollmentPeriod, []))
  end

  def enrollment_careers
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
      advisors: advisors,
      scheduleOfClasses: schedule_of_classes_period,
      enrollmentPeriods: enrollment_periods,
      enrollmentCareers: enrollment_careers,
      enrolledClasses: enrolled_classes,
      waitlistedClasses: waitlisted_classes,
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
