describe User::Academics::Enrollment::Advisor do
  subject { build(:user_academics_enrollment_advisor) }

  its(:id) { should be_an_instance_of String }
  its(:name) { should be_an_instance_of String }
  its(:title) { should eq 'Instructor' }
  its(:emailAddress) { should be_an_instance_of String }
  its(:email_address) { should be_an_instance_of String }
  its(:program) { should eq 'Undergrad Letters & Science' }
  its(:plan) { should eq 'Computer Science BA' }
end
