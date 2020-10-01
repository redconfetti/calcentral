describe User::Academics::Enrollment::Message do
  let(:career_code) { 'ugrd' }
  let(:semester_name) { 'Spring' }
  let(:message_catalog_data) do
    {
      messageSetNbr: '28000',
      messageNbr: '231',
      messageText: 'UGRD Enrollment Card Call Out Box-Spring',
      msgSeverity: 'M',
      descrlong: nil
    }
  end
  before do
    allow(CampusSolutions::MessageCatalog).to receive(:get_message).with('enrollment_message_ugrd_spring').and_return(message_catalog_data)
  end
  subject { described_class.new(career_code: career_code, semester_name: semester_name) }

  describe '#message' do
    let(:message) { subject.message }
    context 'when key not found in message catalog' do
      before { expect(CampusSolutions::MessageCatalog::CATALOG).to receive(:fetch).and_return(nil) }
      it 'returns nil' do
        expect(message).to eq nil
      end
    end
    context 'when key is found in message catalog' do
      it 'returns message hash' do
        expect(message).to be_an_instance_of Hash
        expect(message[:messageSetNbr]).to eq '28000'
        expect(message[:messageNbr]).to eq '231'
        expect(message[:messageText]).to eq 'UGRD Enrollment Card Call Out Box-Spring'
        expect(message[:msgSeverity]).to eq 'M'
      end
    end
  end
end
