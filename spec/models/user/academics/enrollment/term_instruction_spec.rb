describe User::Academics::Enrollment::TermInstruction do
  let(:user_id) { '61889' }
  let(:user) { User::Current.new(user_id) }
  let(:term_id) { '2208' }

  let(:enrollment_term_data) { attributes_for(:user_academics_enrollment_term_instruction_data) }
  let(:cs_enrollment_term_api_response) { {statusCode: 200, feed: {enrollmentTerm: enrollment_term_data}} }
  let(:cs_enrollment_term_requestor) { double(get: cs_enrollment_term_api_response) }

  # cal grant acknowledgement
  let(:requires_cal_grant_acknowledgement) { true }
  let(:student_attributes) { double(find_by_term_id: [student_attribute]) }
  let(:student_attribute) { double(:requires_cal_grant_acknowledgement? => requires_cal_grant_acknowledgement) }

  before do
    allow(user).to receive(:student_attributes).and_return(student_attributes)
    allow(::CampusSolutions::EnrollmentTerm).to receive(:new).with(user_id: user_id, term_id: term_id).and_return(cs_enrollment_term_requestor)
  end

  subject { described_class.new(user, term_id) }

  its(:term_description) { should eq 'Fall 2020' }
  its(:class_schedule_available?) { should eq true }
  its(:end_of_drop_add_time_period?) { should eq false }

  describe '#requires_cal_grant_acknowledgement?' do
    let(:result) { subject.requires_cal_grant_acknowledgement? }
    it 'indicates if enrollment term requires CalGrant acknowledgement' do
      expect(result).to eq true
    end
  end

  describe '#advisors' do
    let(:advisors) { subject.advisors }
    it 'returns advisors collection object' do
      expect(advisors).to be_an_instance_of ::User::Academics::Enrollment::Advisors
    end
  end

  describe '#enrolled_classes' do
    let(:classes) { subject.enrolled_classes }
    it 'returns enrolled classes object' do
      expect(classes).to be_an_instance_of ::User::Academics::Enrollment::EnrollmentClasses
      expect(classes.type).to eq :enrollment
    end
  end

  describe '#schedule_of_classes_period' do
    let(:result) { subject.schedule_of_classes_period }
    it 'returns date data for schedule of classes period' do
      expect(result).to be_an_instance_of ::User::Academics::Enrollment::Date
      expect(result.pacific).to eq '2020-09-01T00:00:00-07:00'
    end
  end

  describe '#waitlisted_classes' do
    let(:classes) { subject.waitlisted_classes }
    it 'returns waitlisted classes object' do
      expect(classes).to be_an_instance_of ::User::Academics::Enrollment::EnrollmentClasses
      expect(classes.type).to eq :waitlist
    end
  end

  describe '#enrollment_periods' do
    let(:periods) { subject.enrollment_periods }
    it 'returns enrollment periods object' do
      expect(periods).to be_an_instance_of ::User::Academics::Enrollment::Periods
    end
  end

  describe '#enrollment_careers' do
    let(:enrollment_careers) { subject.enrollment_careers }
    it 'returns enrollment careers object' do
      expect(enrollment_careers).to be_an_instance_of ::User::Academics::Enrollment::Careers
    end
  end

  describe '#to_json' do
    let(:json_string) { subject.to_json }
    let(:json_hash) { JSON.parse(json_string) }
    it 'returns hash representations for json output' do
      expect(json_hash).to be_an_instance_of Hash
      expect(json_hash['user']).to eq user_id
      expect(json_hash['term_id']).to eq term_id
      expect(json_hash['advisors'].count).to eq 1
      expect(json_hash['advisors'][0]['id']).to be
      expect(json_hash['advisors'][0]['name']).to be
      expect(json_hash['advisors'][0]['emailAddress']).to be
      expect(json_hash['advisors'][0]['plan']).to eq 'Computer Science BA'
      expect(json_hash['advisors'][0]['program']).to eq 'Undergrad Letters & Science'
      expect(json_hash['advisors'][0]['title']).to eq 'Instructor'
      expect(json_hash['scheduleOfClasses']['pacific']).to eq '2020-09-01T00:00:00-07:00'
      expect(json_hash['enrollmentPeriods'].count).to eq 1
      expect(json_hash['enrollmentPeriods'][0]['id']).to eq 'PRI1'
      expect(json_hash['enrollmentCareers'].count).to eq 1
      expect(json_hash['enrollmentCareers'][0]['acadCareer']).to eq 'UGRD'
      expect(json_hash['enrolledClasses'].count).to eq 1
      expect(json_hash['enrolledClasses'][0]['id']).to be_an_instance_of String
      expect(json_hash['waitlistedClasses'].count).to eq 1
      expect(json_hash['waitlistedClasses'][0]['id']).to be_an_instance_of String
      expect(json_hash['requiresCalgrantAcknowledgement']).to eq true
    end
  end
end
