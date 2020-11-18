describe HubEdos::StudentApi::V2::Student::Hold do
  let(:attributes) do
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
  subject { described_class.new(attributes) }

  its(:type) { should be_an_instance_of HubEdos::Common::Reference::Descriptor }
  its(:type_code) { should eq 'R01' }
  its(:type_description) { should eq 'Missing Required Documents' }

  its(:reason) { should be_an_instance_of HubEdos::Common::Reference::Descriptor }
  its(:reason_formal_description) { should eq 'A government issue ID is required to receive a Cal 1 Card.' }

  its(:from_term) { should be_an_instance_of HubEdos::StudentApi::V2::Term::Term }
  its(:from_term_id) { should eq '2182' }

  its(:reference) { should eq ' ' }

  its(:amount_required) { should eq 0.0 }

  its(:department) { should be_an_instance_of HubEdos::Common::Reference::Descriptor }

  its(:contact) { should be_an_instance_of HubEdos::Common::Reference::Descriptor }
end
