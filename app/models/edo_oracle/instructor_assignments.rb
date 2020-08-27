class EdoOracle::InstructorAssignments
  def initialize(user)
    @user = user
  end

  def all
    @all ||= data.collect do |instructor_assignment|
      ::EdoOracle::InstructorAssignment.new(instructor_assignment)
    end
  end

  private

  def data
    @data ||= EdoOracle::Queries.get_instructor_assignments(@user.uid)
  end
end
