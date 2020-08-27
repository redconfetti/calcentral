describe EdoOracle::InstructorAssignments do
  let(:current_user) { double(:uid => '61889') }
  let(:instructor_assignment_rows) do
    [
      {
        'term_id' => '2148',
        'session_id' => '1',
        'cs_course_id' => '1234567',
        'offering_number' => 1,
        'section_number' => '100',
        'campus_uid' => '2040',
        'person_name' => 'Dwight K. Schrute',
        'first_name' => 'Dwight',
        'last_name' => 'Schrute',
        'ldap_uid' => '61889',
        'role_code' => 'ICNT',
        'role_description' => 'In Charge but Not Teaching',
        'grade_roster_access' => 'A',
        'print_in_schedule' => 'Y'
      }
    ]
  end
  subject { described_class.new(current_user) }
  before { allow(EdoOracle::Queries).to receive(:get_instructor_assignments).and_return(instructor_assignment_rows) }
  describe '#all' do
    it 'returns all instructor assignment objects' do
      result = subject.all
      expect(result.count).to eq 1
      expect(result[0]).to be_an_instance_of EdoOracle::InstructorAssignment
    end
  end
end
