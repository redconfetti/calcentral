class Api::EnrollmentResources
  def initialize(user_id)
    @user = User::Current.new(user_id)
  end

  def as_json(options={})
    []
  end
end
