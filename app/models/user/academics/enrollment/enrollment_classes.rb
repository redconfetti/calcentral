class User::Academics::Enrollment::EnrollmentClasses
  attr_reader :data
  attr_reader :type

  def initialize(data, type)
    @data = data || []
    @type = type
  end

  def all
    @all ||= data.collect do |class_data|
      ::User::Academics::Enrollment::EnrollmentClass.new(class_data.merge(type: @type))
    end
  end

  def as_json
    all.collect(&:as_json)
  end
end
