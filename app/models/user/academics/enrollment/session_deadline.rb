class User::Academics::Enrollment::SessionDeadline
  attr_accessor :session, :addDeadlineDatetime, :optionDeadlineDatetime

  def initialize(session:, addDeadlineDatetime:, optionDeadlineDatetime:)
    @session = session
    @addDeadlineDatetime = addDeadlineDatetime
    @optionDeadlineDatetime = optionDeadlineDatetime
  end

  def add_deadline
    User::Academics::Enrollment::Date.from_iso_8601(addDeadlineDatetime)
  end

  def option_deadline
    User::Academics::Enrollment::Date.from_iso_8601(optionDeadlineDatetime)
  end

  def as_json(options={})
    {
      session: session,
      addDeadline: add_deadline,
      optionDeadline: option_deadline,
    }
  end
end
