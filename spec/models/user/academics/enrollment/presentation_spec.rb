describe User::Academics::Enrollment::Presentation do
  let(:uid) { '61889' }
  let(:user) { User::Current.new(uid) }
  let(:design) { 'default' }
  let(:term_id) { '2208' }
  let(:term_plan_1_data) do
    {
      'term_id' => '2208',
      'acad_career' => 'UGRD',
      'acad_program' => 'UNODG',
      'acad_plan' => '09V00U'
    }
  end
  let(:term_plan_2_data) do
    {
      'term_id' => '2212',
      'acad_career' => 'UGRD',
      'acad_program' => 'UNODG',
      'acad_plan' => '09V00U'
    }
  end
  let(:term_plan_1) { User::Academics::TermPlans::TermPlan.new(term_plan_1_data) }
  let(:term_plan_2) { User::Academics::TermPlans::TermPlan.new(term_plan_2_data) }
  let(:enrollment_term_plan_1) { User::Academics::Enrollment::TermPlan.new(term_plan_1) }
  let(:enrollment_term_plan_2) { User::Academics::Enrollment::TermPlan.new(term_plan_2) }
  let(:enrollment_term_plans) { [enrollment_term_plan_1, enrollment_term_plan_2] }

  let(:semester_message) { double(as_json: {:text => 'UGRD Enrollment Card Call Out Box-Spring'}) }
  let(:class_info_message) { double(as_json: {:text => 'UGRD Class Information Call Out Box-Spring'}) }

  let(:term) { double(:summer? => false) }

  let(:term_instructions) { double(find_by_term_id: term_instruction) }
  let(:term_instruction) { double(term_id: '2208', enrollment_careers: enrollment_careers) }
  let(:enrollment_careers) { double(find_by_career_code: enrollment_career) }
  let(:enrollment_career) { User::Academics::Enrollment::Career.new(enrollment_career_data) }
  let(:enrollment_career_data) { {acadCareer: 'UGRD', termMaxUnits: '20.5'} }

  before do
    allow(user).to receive(:enrollment_term_instructions).and_return(term_instructions)
    allow(User::Academics::Enrollment::ClassInfoMessage).to receive(:new).and_return(class_info_message)
    allow(User::Academics::Enrollment::SemesterMessage).to receive(:new).and_return(semester_message)
    allow(Terms).to receive(:find_undergraduate).with(term_id).and_return(term)
  end

  subject { described_class.new(user: user, design: design, term_id: term_id, term_plans: enrollment_term_plans) }

  its(:design) { should eq 'default' }
  its(:term_id) { should eq '2208' }
  its(:program_codes) { should eq ['UNODG'] }

  describe '#term_plans' do
    let(:result) { subject.term_plans }
    it 'should return term plans matching design and term id' do
      expect(result).to be_an_instance_of Array
      expect(result.count).to eq 1
      expect(result.first.term_id).to eq '2208'
    end
  end

  describe '#academic_career_code' do
    let(:result) { subject.academic_career_code }
    it 'returns career code from first term plan' do
      expect(result).to eq 'UGRD'
    end
  end

  describe '#to_json' do
    let(:json_string) { subject.to_json }
    let(:json_hash) { JSON.parse(json_string) }
    it 'returns json representation' do
      expect(json_hash).to be_an_instance_of Hash
      expect(json_hash['design']).to eq 'default'
      expect(json_hash['termId']).to eq '2208'
      expect(json_hash['academicCareerCode']).to eq 'UGRD'
      expect(json_hash['programCodes']).to eq ['UNODG']
      expect(json_hash['semesterMessage']['text']).to eq 'UGRD Enrollment Card Call Out Box-Spring'
      expect(json_hash['classInfoMessage']['text']).to eq 'UGRD Class Information Call Out Box-Spring'
      expect(json_hash['termPlans'].count).to eq 1
      expect(json_hash['constraints']['acadCareer']).to eq 'UGRD'
      expect(json_hash['constraints']['maxUnits']).to eq '20.5'
      expect(json_hash['termIsSummer']).to eq false
    end
  end

  describe 'private methods' do
    describe '#term_instruction' do
      let(:result) { subject.send(:term_instruction) }
      it 'returns term instruction for presentation term' do
        expect(result.term_id).to eq '2208'
      end
    end
  end
end
