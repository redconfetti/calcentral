describe User::Academics::Enrollment::Advisor do
  let(:advisor_data) do
    {
      id: '229000',
      name: 'Toby Flenderson',
      emailAddress: 'toby.flenderson@berkeley.edu',
      program: 'Undergrad Letters & Science',
      plan: 'Computer Science BA',
      title: 'Instructor'
    }
  end
  subject { described_class.new(advisor_data) }

  its(:id) { should eq '229000' }
  its(:name) { should eq 'Toby Flenderson' }
  its(:title) { should eq 'Instructor' }
  its(:emailAddress) { should eq 'toby.flenderson@berkeley.edu' }
  its(:email_address) { should eq 'toby.flenderson@berkeley.edu' }
  its(:program) { should eq 'Undergrad Letters & Science' }
  its(:plan) { should eq 'Computer Science BA' }
end
