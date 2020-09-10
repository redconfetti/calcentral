describe User::Academics::Enrollment::EnrollmentClasses do
  let(:type) { :enrollment }
  let(:data) do
    [
      {
        id: '23150',
        acadCareer: 'UGRD',
      },
      {
        id: '23145',
        acadCareer: 'UGRD',
      },
    ]
  end
  subject { described_class.new(data, type) }

  its(:type) { should eq :enrollment }

  describe '#all' do
    let(:enrollment_classes) { subject.all }
    it 'returns all enrollment class objects' do
      expect(enrollment_classes).to be_an_instance_of Array
      expect(enrollment_classes.count).to eq 2
      enrollment_classes.each do |enrollment_class|
        expect(enrollment_class).to be_an_instance_of ::User::Academics::Enrollment::EnrollmentClass
      end
    end
  end
end
