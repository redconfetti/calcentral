describe User::Academics::Holds do
  let(:uid) { '61889' }
  let(:user) { User::Current.new(uid) }
  let(:ihub_hold_data) do
    {
      'type' => {
        'code' => 'R01',
        'description' => 'Missing Required Documents'
      },
      'reason' => {
        'code' => 'NOID',
        'description' => 'No ID Provided at Cal 1 Card',
        'formalDescription' => 'A government issue ID is required to receive a Cal 1 Card.'
      },
      'fromTerm' => {
        'id' => '2182',
        'name' => '2018 Spring',
        'category' => {
          'code' => 'R',
          'description' => 'Regular Term'
        },
        'academicYear' => '2018',
        'beginDate' => '2018-01-09',
        'endDate' => '2018-05-11'
      },
      'toTerm' => {
        'id' => '2182',
        'name' => '2018 Spring',
        'category' => {
          'code' => 'R',
          'description' => 'Regular Term'
        },
        'academicYear' => '2018',
        'beginDate' => '2018-01-09',
        'endDate' => '2018-05-11'
      },
      'reference' => ' ',
      'amountRequired' => 0,
      'department' => {
        'code' => 'UCBKL',
        'description' => 'Department'
      },
      'contact' => {
        'code' => ' ',
        'description' => ' '
      }
    }
  end
  let(:ihub_hold) { HubEdos::StudentApi::V2::Student::Hold.new(ihub_hold_data) }
  let(:ihub_holds) { [ihub_hold] }
  let(:holds_collector) { double(all: ihub_holds, :any? => ihub_holds.any?) }
  before do
    allow(HubEdos::StudentApi::V2::Student::Holds).to receive(:new).and_return(holds_collector)
  end

  subject { described_class.new(user) }

  describe '#all' do
    let(:result) { subject.all }
    it 'returns all academic holds' do
      expect(result).to be_an_instance_of Array
      expect(result.count).to eq 1
      expect(result.first).to be_an_instance_of User::Academics::Hold
      expect(result.first.term_id).to eq '2182'
    end
  end

  describe '#any?' do
    let(:result) { subject.any? }
    context 'when no holds present' do
      let(:ihub_holds) { [] }
      it 'returns false' do
        expect(result).to eq false
      end
    end
    context 'when holds are present' do
      let(:ihub_holds) { [ihub_hold] }
      it 'returns true' do
        expect(result).to eq true
      end
    end
  end

  describe '#find_by_term_id' do
    let(:result) { subject.find_by_term_id(term_id) }
    context 'when term is not present' do
      let(:term_id) { '2188' }
      it 'returns empty array' do
        expect(result).to eq([])
      end
    end
    context 'when term is present' do
      let(:term_id) { '2182' }
      it 'returns holds matching term id' do
        expect(result).to be_an_instance_of Array
        expect(result.first).to be_an_instance_of User::Academics::Hold
      end
    end
  end
end
