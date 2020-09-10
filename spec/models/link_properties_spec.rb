describe LinkProperties do
  let(:properties_data) do
    [
      {name: 'CALCENTRAL', value: 'FORM'},
      {name: 'NEW_WINDOW', value: 'Y'},
      {name: 'UCFROM', value: 'CalCentral'},
      {name: 'UCFROMLINK', value: 'https://calcentral-dev-01.ist.berkeley.edu/'},
      {name: 'UCFROMTEXT', value: 'CalCentral'},
      {name: 'URI_TYPE', value: 'PL'},
    ]
  end
  subject { described_class.new(properties_data) }

  describe '#all' do
    let(:all_properties) { subject.all }
    context 'when properties data is nil' do
      let(:properties_data) { nil }
      it 'returns an empty array' do
        expect(all_properties).to eq []
      end
    end
    context 'when properties is empty' do
      let(:properties_data) { [] }
      it 'returns an empty array' do
        expect(all_properties).to eq []
      end
    end
    context 'when properties are present' do
      it 'returns properties array' do
        expect(all_properties).to be_an_instance_of Array
        expect(all_properties.count).to eq 6
        all_properties.each do |property|
          expect(property).to be_an_instance_of LinkProperty
        end
      end
    end
  end

  describe '#find_by_name' do
    let(:name) { 'UCFROM' }
    let(:found_property) { subject.find_by_name(name) }
    it 'returns property matching name' do
      expect(found_property).to be_an_instance_of LinkProperty
      expect(found_property.name).to eq 'UCFROM'
      expect(found_property.value).to eq 'CalCentral'
    end
  end
end
