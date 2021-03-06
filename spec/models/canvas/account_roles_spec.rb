describe Canvas::AccountRoles do

  subject { Canvas::AccountRoles.new(account_id: account_id, fake: true)}

  let(:department_account_id) {128847}
  let(:project_account_id) {1379095}

  shared_examples 'a bCourses account' do
    it 'includes account-level roles in the raw proxy call' do
      result = subject.roles_list
      expect(result.select {|r| r['base_role_type'] == 'AccountMembership'}).to be_present
    end
    it 'omits account-level roles in the course roles list' do
      result = subject.defined_course_roles
      expect(result.select {|r| r['base_role_type'] == 'AccountMembership'}).to be_empty
    end
  end

  context 'when an academic department subaccount' do
    let(:account_id) {department_account_id}
    it_behaves_like 'a bCourses account'
    it 'has defined course roles' do
      result = subject.defined_course_roles
      expect(result).not_to be_nil
    end
    it 'has the extra official course roles' do
      result = subject.defined_course_roles
      labels = result.collect {|r| r['label']}
      expect(labels).to include('Lead TA', 'Reader', 'Waitlist Student')
    end
    it 'sorts to match the default Canvas UX' do
      result = subject.defined_course_roles
      labels = result.collect {|r| r['label']}
      expect(labels).to eq ['Student', 'Waitlist Student', 'Teacher', 'TA', 'Lead TA', 'Reader', 'Designer', 'Observer']
    end
  end
  context 'when a project sites account' do
    let(:account_id) {project_account_id}
    it_behaves_like 'a bCourses account'
    it 'has defined course roles' do
      result = subject.defined_course_roles
      expect(result).not_to be_nil
    end
    it 'has the extra project site roles' do
      result = subject.defined_course_roles
      labels = result.collect {|r| r['label']}
      expect(labels).to include('Member', 'Owner', 'Maintainer')
    end
  end

  context 'when an invalid account' do
    let(:account_id) {000000}
    it 'does not have defined course roles' do
      result = subject.defined_course_roles
      expect(result).to eq([])
    end
  end

end
