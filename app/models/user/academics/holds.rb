class User::Academics::Holds
  attr_reader :user

  def initialize(user)
    @user = user
  end

  delegate :any?, to: :ihub_holds

  def all
    @all ||= ihub_holds.all.map do |hold|
      ::User::Academics::Hold.new(hold)
    end
  end

  def find_by_term_id(term_id)
    all.select do |hold|
      hold.term_id == term_id
    end
  end

  private

  def ihub_holds
    HubEdos::StudentApi::V2::Student::Holds.new(user)
  end
end
