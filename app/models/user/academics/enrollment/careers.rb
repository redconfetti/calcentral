class User::Academics::Enrollment::Careers
  attr_reader :data

  def initialize(data = [])
    @data = data
  end

  def all
    @all ||= data.collect do |career_data|
      ::User::Academics::Enrollment::Career.new(career_data)
    end
  end

  def find_by_career_code(career_code)
    all.select do |career|
      career.career_code.downcase == career_code.downcase
    end.first
  end
end
