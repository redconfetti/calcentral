describe User::Academics::Enrollment::Career do
  subject { build(:user_academics_enrollment_career) }

  its(:academic_career_code) { should eq 'UGRD' }
  its(:term_max_units) { should eq '20.5' }
  its(:session_deadlines) { should be_an_instance_of Array }

  describe '#to_json' do
    let(:json_string) { subject.to_json }
    let(:json_hash) { JSON.parse(json_string) }
    it 'returns json hash representation' do
      expect(json_hash).to be_an_instance_of Hash
      expect(json_hash['acadCareer']).to eq 'UGRD'
      expect(json_hash['maxUnits']).to eq '20.5'
      expect(json_hash['sessionDeadlines'][0]['session']).to eq 'Regular Academic Session'
      expect(json_hash['sessionDeadlines'][0]['addDeadline']['unixTimestamp']).to eq 1613001540
    end
  end
end
