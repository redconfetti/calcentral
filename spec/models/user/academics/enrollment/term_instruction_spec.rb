describe User::Academics::Enrollment::TermInstruction do
  let(:user_id) { '61889' }
  let(:user) { double(:user, uid: user_id) }
  let(:term_id) { '2208' }
  let(:enrollment_term_data) do
    {
      statusCode: 200,
      feed: enrollment_term_feed
    }
  end
  let(:enrollment_term_feed) do
    {
      enrollmentTerm: {
        studentId: '11667051',
        term: '2208',
        termDescr: 'Fall 2020',
        advisors: [],
        isClassScheduleAvailable: true,
        isEndOfDropAddTimePeriod: true,
        links: links_data,
        enrollmentPeriod: enrollment_periods,
        careers: careers,
        scheduleOfClassesPeriod: schedule_of_classes_period_data,
        enrolledClasses: enrolled_classes,
        enrolledClassesTotalUnits: 0.0,
        waitlistedClasses: waitlist_classes,
        waitlistedClassesTotalUnits: 0.0,
      }
    }
  end
  let(:enrollment_periods) { [{career: 'UGRD', :id => 'PRI1', date: {epoch: 1586806200}, enddatetime: '2020-06-12T23:59:00'}] }
  let(:enrollment_careers) { [{acadCareer: 'UGRD'}] }
  let(:links_data) do
    {
      addEnrolledClasses: {
        name: 'Add enrolled classes',
        url: 'https://bcsdev.is.berkeley.edu/psp/bcsdev/EMPLOYEE/SA/c/SA_LEARNER_SERVICES_2.SSR_SSENRL_CART.GBL?',
        isCsLink: true
      }
    }
  end
  let(:careers) { [{:acadCareer=>"UGRD"}] }
  let(:schedule_of_classes_period_data) { {date: {epoch: 1598943600}} }
  let(:enrolled_classes) { [{id: '23150'}, {id: '23145'}, {id: '23151'}] }
  let(:waitlist_classes) { [{id: '23180'}] }
  let(:enrollment_term_requestor) { double(get: enrollment_term_data) }
  before do
    allow(::CampusSolutions::EnrollmentTerm).to receive(:new).with(user_id: user_id, term_id: term_id).and_return(enrollment_term_requestor)
  end
  subject { described_class.new(user, term_id) }

  its(:term_description) { should eq 'Fall 2020' }
  its(:class_schedule_available?) { should eq true }
  its(:end_of_drop_add_time_period?) { should eq true }

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
      expect(json_hash['advisors']).to eq []
      expect(json_hash['scheduleOfClasses']['pacific']).to eq '2020-09-01T00:00:00-07:00'
      expect(json_hash['enrollmentPeriods'].count).to eq 1
      expect(json_hash['enrollmentPeriods'][0]['id']).to eq 'PRI1'
      expect(json_hash['enrollmentCareers'].count).to eq 1
      expect(json_hash['enrollmentCareers'][0]['acadCareer']).to eq 'UGRD'
      expect(json_hash['enrolledClasses'].count).to eq 3
      expect(json_hash['enrolledClasses'][0]['id']).to eq '23150'
      expect(json_hash['enrolledClasses'][1]['id']).to eq '23145'
      expect(json_hash['enrolledClasses'][2]['id']).to eq '23151'
      expect(json_hash['waitlistedClasses'].count).to eq 1
      expect(json_hash['waitlistedClasses'][0]['id']).to eq '23180'
    end
  end
end
