describe User::Academics::Hold do
  let(:ihub_hold_type_code) { 'R01' }
  let(:ihub_hold_data) do
    {
      'type' => {
        'code' => ihub_hold_type_code,
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
  subject { described_class.new(ihub_hold) }

  describe '#calgrant?' do
    context 'when hold has type code \'F06\'' do
      let(:ihub_hold_type_code) { 'F06' }
      it 'returns true' do
        expect(subject.calgrant?).to eq true
      end
    end
    context 'when hold does not have type code \'F06\'' do
      let(:ihub_hold_type_code) { 'R01' }
      it 'returns false' do
        expect(subject.calgrant?).to eq false
      end
    end
  end

end
