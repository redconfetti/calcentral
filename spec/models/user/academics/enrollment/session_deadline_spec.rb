describe User::Academics::Enrollment::SessionDeadline do
  subject { build(:user_academics_enrollment_session_deadline) }

  its(:session) { should eq 'Regular Academic Session' }
  its(:add_deadline) { should be_an_instance_of User::Academics::Enrollment::Date }
  its('add_deadline.utc') { should eq '2021-02-10T23:59:00+00:00' }
  its(:option_deadline) { should be_an_instance_of User::Academics::Enrollment::Date }
  its('option_deadline.utc') { should eq '2021-04-02T23:59:00+00:00' }

  describe '#to_json' do
    let(:json_string) { subject.to_json }
    let(:json_hash) { JSON.parse(json_string) }
    it 'provides json representation' do
      expect(json_hash).to be_an_instance_of Hash
      expect(json_hash['session']).to eq 'Regular Academic Session'
      expect(json_hash['addDeadline']).to be_an_instance_of Hash
      expect(json_hash['addDeadline']['utc']).to eq '2021-02-10T23:59:00+00:00'
      expect(json_hash['addDeadline']['pacific']).to eq '2021-02-10T15:59:00-08:00'
      expect(json_hash['optionDeadline']).to be_an_instance_of Hash
      expect(json_hash['optionDeadline']['utc']).to eq '2021-04-02T23:59:00+00:00'
      expect(json_hash['optionDeadline']['pacific']).to eq '2021-04-02T16:59:00-07:00'
    end
  end
end
