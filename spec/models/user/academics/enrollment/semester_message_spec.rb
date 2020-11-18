describe User::Academics::Enrollment::SemesterMessage do
  let(:academic_career_code) { 'UGRD' }
  let(:semester_name) { 'Spring' }
  let(:term_id) { '2212' }
  let(:term) { double(:id => term_id, :type => semester_name) }
  let(:message_catalog_data) do
    {
      messageSetNbr: '28000',
      messageNbr: '231',
      messageText: 'UGRD Enrollment Card Call Out Box-Spring',
      msgSeverity: 'M',
      descrlong: '<p>The Spring 2021 class schedule is available to view.</p>'
    }
  end
  before do
    allow(CampusSolutions::MessageCatalog).to receive(:get_message).with('enrollment_message_ugrd_spring').and_return(message_catalog_data)
    allow(Terms).to receive(:find_undergraduate).and_return(term)
  end
  subject { described_class.new(term_id: term_id, academic_career_code: academic_career_code) }

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

  describe '#text' do
    it 'returns message text' do
      expect(subject.text).to eq 'UGRD Enrollment Card Call Out Box-Spring'
    end
  end

  describe '#description' do
    it 'returns message description' do
      expect(subject.description).to eq '<p>The Spring 2021 class schedule is available to view.</p>'
    end
  end

  describe '#as_json' do
    let(:json) { subject.as_json }
    it 'returns json representation of message' do
      expect(json).to be_an_instance_of Hash
      expect(json[:text]).to eq 'UGRD Enrollment Card Call Out Box-Spring'
      expect(json[:description]).to eq '<p>The Spring 2021 class schedule is available to view.</p>'
    end
  end

  context 'private methods' do
    describe '#key' do
      it 'returns lower case message key' do
        expect(subject.send(:key)).to eq 'enrollment_message_ugrd_spring'
      end
    end
    describe '#semester_name' do
      it 'returns semester name in lowercase letters' do
        expect(subject.send(:semester_name)).to eq 'spring'
      end
    end
  end

end
