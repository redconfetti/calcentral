class HubEdos::StudentApi::V2::Student::Holds
  attr_reader :user

  def initialize(user)
    @user = user
  end

  def any?
    all.any?
  end

  def all
    @all ||= feed_data.collect do |hold_data|
      ::HubEdos::StudentApi::V2::Student::Hold.new(hold_data)
    end
  end

  private

  def feed_data
    @feed_data ||= begin
      response = HubEdos::StudentApi::V2::Feeds::AcademicStatuses.new({ user_id: user.uid }).get
      response[:feed]['holds'] || []
    rescue NoMethodError
      []
    end
  end

end
