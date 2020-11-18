describe LinkProperty do
  let(:link_property_data) { {name: 'NEW_WINDOW', value: 'Y'} }
  subject { described_class.new(link_property_data) }

  its(:name) { should eq 'NEW_WINDOW' }
  its(:value) { should eq 'Y' }
end
