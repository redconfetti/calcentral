describe User::Academics::Enrollment::Term do
  let(:attributes) do
    {
      termId: '2212',
      termDescr: '2021 Spring',
      acadCareer: 'UGRD',
      student_attributes: student_attributes,
      enrollment_instructions: enrollment_instructions,
      term_plans: term_plans,
    }
  end
  let(:requires_cal_grant_acknowledgement) { true }
  let(:student_attribute) { double(:requires_cal_grant_acknowledgement? => requires_cal_grant_acknowledgement) }
  let(:enrollment_instructions) { double(find_by_term_id: enrollment_instruction) }
  let(:enrollment_instruction) { double(enrollment_periods: enrollment_periods, enrollment_careers: enrollment_careers) }
  let(:enrollment_periods) { double(for_career: [enrollment_period]) }
  let(:enrollment_period) { double(:enrollment_period, acadCareer: 'UGRD') }
  let(:enrollment_career) { double(:enrollment_career, acadCareer: 'UGRD')}
  let(:enrollment_careers) { double(find_by_career_code: [enrollment_career]) }
  let(:student_attributes) { double(find_by_term_id: [student_attribute]) }
  let(:term_plans) { double(find_by_term_id_and_career_code: term_plan) }
  let(:term_plan) { double(term_id: '2212', academic_program_code: 'UCLS')}
  let(:spring_2021_term) { double(term_id: '2212', semester_name: 'Spring 2021') }
  let(:class_info_message) { double(message: 'this is the class info message') }
  let(:enrollment_message) { double(message: 'this is the enrollment message') }
  before do
    allow(::User::Academics::Term).to receive(:new).and_return(spring_2021_term)
    allow(::User::Academics::ClassInfoMessage).to receive(:new).and_return(class_info_message)
    allow(::User::Academics::Enrollment::Message).to receive(:new).and_return(enrollment_message)
  end
  subject { described_class.new(attributes) }

  describe '#requires_cal_grant_acknowledgement?' do
    let(:result) { subject.requires_cal_grant_acknowledgement? }
    it 'indicates if enrollment term requires CalGrant acknowledgement' do
      expect(result).to eq true
    end
  end

  describe '#as_json' do
    let(:result) { subject.as_json }
    it 'returns hash representation of enrollment term' do
      expect(result).to be_an_instance_of Hash
      expect(result[:career]).to eq 'ugrd'
      expect(result[:termId]).to eq '2212'
      expect(result[:requiresCalgrantAcknowledgement]).to eq true
      expect(result[:message]).to eq 'this is the enrollment message'
      expect(result[:classInfoMessage]).to eq 'this is the class info message'
      expect(result[:enrollmentPeriods][0].acadCareer).to eq 'UGRD'
      expect(result[:constraints][0].acadCareer).to eq 'UGRD'
      expect(result[:programCode]).to eq 'UCLS'
    end
  end
end
