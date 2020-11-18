describe Api::EnrollmentResources do
  let(:user_id) { '61889' }
  let(:user) { double(uid: user_id) }

  before do
    allow(User::Current).to receive(:new).with(user_id).and_return(user)
    allow(user).to receive(:enrollment_links).and_return('enrollment_links')
    allow(user).to receive(:enrollment_messages).and_return('enrollment_messages')
    allow(user).to receive(:enrollment_presentations).and_return('enrollment_presentations')
    allow(user).to receive(:enrollment_term_instructions).and_return('enrollment_term_instructions')
    allow(user).to receive(:has_holds?).and_return(false)
  end

  subject { described_class.new(user_id) }

  describe '#to_json' do
    let(:json_string) { subject.to_json }
    let(:json_hash) { JSON.parse(json_string) }

    it 'returns json representation of enrollment resources' do
      expect(json_hash).to be_an_instance_of Hash
      expect(json_hash['presentations']).to eq 'enrollment_presentations'
      expect(json_hash['termInstructions']).to eq 'enrollment_term_instructions'
      expect(json_hash['links']).to eq 'enrollment_links'
      expect(json_hash['messages']).to eq 'enrollment_messages'
      expect(json_hash['hasHolds']).to eq false
    end
  end

end
