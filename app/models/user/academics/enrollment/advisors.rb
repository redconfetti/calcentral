class User::Academics::Enrollment::Advisors
  attr_reader :data

  def initialize(data)
    @data = data || []
  end

  def all
    @all ||= data.collect do |advisor_data|
      ::User::Academics::Enrollment::Advisor.new(advisor_data)
    end
  end

  def as_json
    all.collect(&:as_json)
  end
end
