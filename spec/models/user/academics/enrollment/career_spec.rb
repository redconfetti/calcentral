describe User::Academics::Enrollment::Career do
  let(:enrollment_career_attributes) do
    {
      acadCareer: 'UGRD',
      termMaxUnits: '20.5',
      sessionDeadlines: [
        {
          session: 'Regular Academic Session',
          addDeadlineDatetime: '2021-02-10T23:59:00',
          optionDeadlineDatetime: '2021-04-02T23:59:00'
        }
      ]
    }
  end
  subject { described_class.new(enrollment_career_attributes) }

  its(:career_code) { should eq 'UGRD' }
  its(:term_max_units) { should eq '20.5' }
  its(:session_deadlines) { should be_an_instance_of Array }

  describe '#as_json' do
    let(:json_hash) { subject.as_json }
    it 'returns json hash representation' do
      expect(json_hash).to be_an_instance_of Hash
      expect(json_hash[:acadCareer]).to eq 'UGRD'
      expect(json_hash[:maxUnits]).to eq '20.5'
      expect(json_hash[:deadlines][0][:session]).to eq 'Regular Academic Session'
    end
  end
end
