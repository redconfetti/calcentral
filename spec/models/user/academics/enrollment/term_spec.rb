describe User::Academics::Enrollment::Term do
  let(:uid) { '61889' }
  let(:user) { User::Current.new(uid) }
  let(:attributes) do
    {
      termId: '2212',
      termDescr: '2021 Spring',
      acadCareer: 'UGRD',
      user: user
    }
  end

  # term
  let(:spring_2021_term) { double(term_id: '2212', semester_name: 'Spring 2021', :summer? => false) }

  # cal grant acknowledgement
  let(:requires_cal_grant_acknowledgement) { true }
  let(:student_attributes) { double(find_by_term_id: [student_attribute]) }
  let(:student_attribute) { double(:requires_cal_grant_acknowledgement? => requires_cal_grant_acknowledgement) }

  # student term plan
  let(:term_plans) { double(find_by_term_id_and_career_code: term_plan) }
  let(:term_plan) { double(term_id: '2212', academic_program_code: 'UCLS')}

  # messages
  let(:class_info_message_as_json) { {:text => 'this is the class info message', :description => 'this is the class info message description'} }
  let(:enrollment_message_as_json) { {:text => 'this is the enrollment message', :description => 'this is the enrollment message description'} }
  let(:class_info_message) { double(:as_json => class_info_message_as_json) }
  let(:enrollment_message) { double(:as_json => enrollment_message_as_json) }

  # term instruction
  let(:term_instructions) { double(find_by_term_id: term_instruction) }
  let(:term_instruction) { double(enrollment_periods: enrollment_periods, enrollment_careers: enrollment_careers) }
  let(:enrollment_careers) { double(find_by_career_code: [enrollment_career]) }
  let(:enrollment_career) { double(as_json: enrollment_career_hash)}
  let(:enrollment_career_hash) { {acadCareer: 'UGRD', termMaxUnits: '20.5', sessionDeadlines: []} }
  let(:enrollment_periods) { double(for_career: [enrollment_period]) }
  let(:enrollment_period) { double(as_json: enrollment_period_hash) }
  let(:enrollment_period_hash) { {id: 'PRI1', name: 'Phase 1 Begins'} }

  before do
    allow(::Terms).to receive(:find_undergraduate).with('2212').and_return(spring_2021_term)
    allow(::User::Academics::Enrollment::TermInstructions).to receive(:new).and_return(term_instructions)
    allow(::User::Academics::Enrollment::ClassInfoMessage).to receive(:new).and_return(class_info_message)
    allow(::User::Academics::Enrollment::Message).to receive(:new).and_return(enrollment_message)
    allow(user).to receive(:student_attributes).and_return(student_attributes)
    allow(user).to receive(:term_plans).and_return(term_plans)
  end

  subject { described_class.new(attributes) }

  describe '#requires_cal_grant_acknowledgement?' do
    let(:result) { subject.requires_cal_grant_acknowledgement? }
    it 'indicates if enrollment term requires CalGrant acknowledgement' do
      expect(result).to eq true
    end
  end

  describe '#to_json' do
    let(:result) { subject.to_json }
    let(:json) { JSON.parse(result) }
    it 'returns hash representation of enrollment term' do
      expect(json).to be_an_instance_of Hash
      expect(json['termId']).to eq '2212'
      expect(json['career']).to eq 'ugrd'
      expect(json['programCode']).to eq 'UCLS'
      expect(json['requiresCalgrantAcknowledgement']).to eq true
      expect(json['message']['text']).to eq 'this is the enrollment message'
      expect(json['message']['description']).to eq 'this is the enrollment message description'
      expect(json['classInfoMessage']['text']).to eq 'this is the class info message'
      expect(json['classInfoMessage']['description']).to eq 'this is the class info message description'
      expect(json['enrollmentPeriods'][0]['id']).to eq 'PRI1'
      expect(json['enrollmentPeriods'][0]['name']).to eq 'Phase 1 Begins'
      expect(json['constraints'][0]['acadCareer']).to eq 'UGRD'
      expect(json['constraints'][0]['termMaxUnits']).to eq '20.5'
    end
  end

end
