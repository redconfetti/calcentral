class User::Academics::Enrollment::Period
  attr_accessor :id
  attr_accessor :acadCareer
  attr_accessor :enddatetime
  attr_accessor :name
  attr_accessor :date

  alias :career :acadCareer

  def initialize(attrs={})
    attrs.each do |key, value|
      send("#{key}=", value) if respond_to?("#{key}=")
    end
  end

  def begin_time
    User::Academics::Enrollment::Date.new(date)
  end

  def end_time
    User::Academics::Enrollment::Date.new(iso_8601_string: enddatetime)
  end

  def as_json(options={})
    {
      id: id,
      acadCareer: career,
      beginTime: begin_time,
      endTime: end_time,
      name: name,
    }
  end
end
