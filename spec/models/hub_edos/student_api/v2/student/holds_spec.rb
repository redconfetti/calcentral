describe HubEdos::StudentApi::V2::Student::Holds do
  let(:uid) { '61889' }
  let(:user) { User::Current.new(uid) }
  let(:hold_data) do
    {'type' => {'code'=>'R01', 'description'=>'Missing Required Documents'}}
  end
  let(:holds_data) { [hold_data] }
  let(:academic_statuses_feed) { {feed: {'holds' => holds_data}} }
  let(:academic_statuses_object) { double(get: academic_statuses_feed) }

  before do
    allow(HubEdos::StudentApi::V2::Feeds::AcademicStatuses).to receive(:new).and_return(academic_statuses_object)
  end

  subject { described_class.new(user) }

  describe '#any?' do
    let(:result) { subject.any? }
    context 'when no holds present' do
      let(:holds_data) { [] }
      it 'returns false' do
        expect(result).to eq false
      end
    end
    context 'when holds are present' do
      let(:holds_data) { [hold_data] }
      it 'returns true' do
        expect(result).to eq true
      end
    end
  end

  describe '#all' do
    let(:result) { subject.all }
    it 'returns holds collection' do
      expect(result).to be_an_instance_of Array
      expect(result.count).to eq 1
      expect(result.first).to be_an_instance_of HubEdos::StudentApi::V2::Student::Hold
    end
  end
end
