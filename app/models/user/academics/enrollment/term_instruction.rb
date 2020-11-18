class User::Academics::Enrollment::TermInstruction
  attr_reader :user
  attr_reader :term_id
  attr_accessor :data

  def initialize(user, term_id)
    @user = user
    @term_id = term_id
  end

  def class_schedule_available?
    data.fetch(:isClassScheduleAvailable) { nil }
  end

  def end_of_drop_add_time_period?
    data.fetch(:isEndOfDropAddTimePeriod) { nil }
  end

  def term_description
    data.fetch(:termDescr) { nil }
  end

  def schedule_of_classes_period
    date = data.fetch(:scheduleOfClassesPeriod) { Hash.new }.dig(:date, :epoch)
    User::Academics::Enrollment::Date.from_unix_timestamp(date)
  end

  def requires_cal_grant_acknowledgement?
    student_attributes
      .find_by_term_id(term_id)
      .any?(&:requires_cal_grant_acknowledgement?)
  end

  def advisors
    @advisors ||= ::User::Academics::Enrollment::Advisors.new(data.fetch(:advisors) { [] })
  end

  def enrollment_periods
    @enrollment_periods ||= ::User::Academics::Enrollment::Periods.new(data.fetch(:enrollmentPeriod) { [] })
  end

  def enrollment_careers
    @enrollment_careers ||= ::User::Academics::Enrollment::Careers.new(data.fetch(:careers) { [] })
  end

  def enrolled_classes
    @enrolled_classes ||= ::User::Academics::Enrollment::EnrollmentClasses.new(data.fetch(:enrolledClasses) { [] }, :enrollment)
  end

  def waitlisted_classes
    @waitlisted_classes ||= ::User::Academics::Enrollment::EnrollmentClasses.new(data.fetch(:waitlistedClasses) { [] }, :waitlist)
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
      requiresCalgrantAcknowledgement: requires_cal_grant_acknowledgement?,
    }
  end

  private

  def data
    @data ||= ::CampusSolutions::EnrollmentTerm.new(user_id: user.uid, term_id: term_id).get.dig(:feed, :enrollmentTerm)
  end

  def student_attributes
    user.student_attributes
  end
end
