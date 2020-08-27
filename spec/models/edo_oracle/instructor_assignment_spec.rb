describe EdoOracle::InstructorAssignment do
  let(:attributes) do
    {
      'term_id' => '2148',
      'session_id' => '1',
      'cs_course_id' => '1234567',
      'offering_number' => 1,
      'section_number' => '100',
      'ldap_uid' => '2040',
      'person_name' => 'Dwight K. Schrute',
      'first_name' => 'Dwight',
      'last_name' => 'Schrute',
      'role_code' => 'ICNT',
      'role_description' => 'In Charge but Not Teaching',
      'grade_roster_access' => 'A',
      'print_in_schedule' => 'Y'
    }
  end
  subject { described_class.new(attributes) }
  its(:term_id) { should eq '2148' }
  its(:session_id) { should eq '1' }
  its(:cs_course_id) { should eq '1234567' }
  its(:offering_number) { should eq 1 }
  its(:section_number) { should eq '100' }
  its(:ldap_uid) { should eq '2040' }
  its(:person_name) { should eq 'Dwight K. Schrute' }
  its(:first_name) { should eq 'Dwight' }
  its(:last_name) { should eq 'Schrute' }
  its(:role_code) { should eq 'ICNT' }
  its(:role_description) { should eq 'In Charge but Not Teaching' }
  its(:grade_roster_access) { should eq 'A' }
  its(:print_in_schedule) { should eq 'Y' }

  describe '#to_json' do
    let(:result) { JSON.parse(subject.to_json) }
    it 'should include term id' do
      expect(result['term_id']).to eq('2148')
    end
    it 'should include session id' do
      expect(result['session_id']).to eq('1')
    end
    it 'should include cs course id' do
      expect(result['cs_course_id']).to eq('1234567')
    end
    it 'should include offering number' do
      expect(result['offering_number']).to eq(1)
    end
    it 'should include section number' do
      expect(result['section_number']).to eq('100')
    end
    it 'should include ldap uid' do
      expect(result['ldap_uid']).to eq('2040')
    end
    it 'should include person name' do
      expect(result['person_name']).to eq('Dwight K. Schrute')
    end
    it 'should include first name' do
      expect(result['first_name']).to eq('Dwight')
    end
    it 'should include last name' do
      expect(result['last_name']).to eq('Schrute')
    end
    it 'should include role code' do
      expect(result['role_code']).to eq('ICNT')
    end
    it 'should include role description' do
      expect(result['role_description']).to eq('In Charge but Not Teaching')
    end
    it 'should include grade_roster_access' do
      expect(result['grade_roster_access']).to eq('A')
    end
    it 'should include print_in_schedule' do
      expect(result['print_in_schedule']).to eq('Y')
    end
  end

end
