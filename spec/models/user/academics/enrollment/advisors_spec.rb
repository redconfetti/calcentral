describe User::Academics::Enrollment::Advisors do
  let(:advisors_data) do
    [
      {
        id: '229000',
        name: 'Toby Flenderson',
        emailAddress: 'toby.flenderson@berkeley.edu',
        program: 'Undergrad Letters & Science',
        plan: 'Computer Science BA',
        title: 'Instructor'
      },
      {
        id: '279000',
        name: 'Erin Hannon',
        emailAddress: 'ehannon@berkeley.edu',
        program: 'Undergrad Letters & Science',
        plan: 'Computer Science BA',
        title: nil
      }
    ]
  end
  subject { described_class.new(advisors_data) }

  describe '#all' do
    let(:result) { subject.all }
    it 'returns collection of advisors' do
      expect(result).to be_an_instance_of Array
      expect(result.count).to eq 2
      result.each do |advisor|
        expect(advisor).to be_an_instance_of ::User::Academics::Enrollment::Advisor
      end
    end
  end
end
