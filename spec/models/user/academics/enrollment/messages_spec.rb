describe User::Academics::Enrollment::Messages do
  let(:waitlisted_units_warning_data) do
    {
      waitlisted_units_warning: {
        messageSetNbr: '28000',
        messageNbr: '216',
        messageText: 'Waitlist Warning Message',
        msgSeverity: 'W',
        descrlong: 'Note that waitlisted units will count toward the total units limit during each enrollment phase.  Waitlisted units do not count toward financial aid eligibility.'
      }
    }
  end
  before do
    allow(CampusSolutions::MessageCatalog).to receive(:get_message_collection).with([:waitlisted_units_warning]).and_return(waitlisted_units_warning_data)
  end

  describe '#waitlisted_units_warning' do
    let(:result) { subject.waitlisted_units_warning }
    it 'returns waitlisted units warning message' do
      expect(result).to be_an_instance_of Hash
      expect(result[:messageSetNbr]).to eq '28000'
      expect(result[:messageNbr]).to eq '216'
    end
  end

  describe '#to_json' do
    let(:json_string) { subject.to_json }
    let(:json_hash) { JSON.parse(json_string) }
    it 'returns in json format' do
      expect(json_hash).to be_an_instance_of Hash
      expect(json_hash['waitlistedUnitsWarning']).to be_an_instance_of Hash
      expect(json_hash['waitlistedUnitsWarning']['messageSetNbr']).to eq '28000'
    end
  end

end
