class User::Academics::Enrollment::Career
  attr_accessor :acadCareer
  attr_accessor :termMaxUnits
  attr_accessor :sessionDeadlines

  alias :academic_career_code :acadCareer
  alias :term_max_units :termMaxUnits
  alias :session_deadlines :sessionDeadlines

  def initialize(attrs = {})
    attrs.each do |key, value|
      send("#{key}=", value) if respond_to?("#{key}=")
    end
  end

  def session_deadlines
    sessionDeadlines.to_a.collect {|sd| User::Academics::Enrollment::SessionDeadline.new(sd) }
  end

  def as_json(options={})
    {
      acadCareer: academic_career_code,
      maxUnits: term_max_units,
      sessionDeadlines: session_deadlines
    }
  end
end
