class User::Academics::Enrollment::Advisor
  attr_accessor :id
  attr_accessor :name
  attr_accessor :title
  attr_accessor :emailAddress
  attr_accessor :program
  attr_accessor :plan

  alias :email_address :emailAddress

  def initialize(attrs = {})
    attrs.each do |key, value|
      send("#{key}=", value) if respond_to?("#{key}=")
    end
  end
end
