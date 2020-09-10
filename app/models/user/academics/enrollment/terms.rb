class User::Academics::Enrollment::Terms
  attr_accessor :user

  def initialize(user)
    self.user = user
  end

  def all
    @all ||= enrollments_data.collect do |data|
      ::User::Academics::Enrollment::Term.new(data.merge({user: user}))
    end
  end

  def as_json(options={})
    all.map(&:as_json)
  end

  private

  def enrollments_data
    @enrollments_data = CampusSolutions::EnrollmentTerms
      .new({ user_id: user.uid }).get[:feed][:enrollmentTerms]
  rescue NoMethodError
    []
  end

end
