describe User::Academics::Enrollment::Terms do
  let(:user_uid) { '61889' }
  let(:user_term_plans) { [double(:user_term_plan)] }
  let(:user) { double(:user, :uid => user_uid) }
  let(:student_id) { '1000001' }
  let(:enrollment_terms) do
    [
      {
        termId: '2208',
        termDescr: '2020 Fall',
        acadCareer: 'UGRD',
      },
      {
        termId: '2212',
        termDescr: '2021 Spring',
        acadCareer: 'UGRD',
      }
    ]
  end
  let(:cs_enrollment_terms_response) do
    {
      statusCode: 200,
      feed: {
        studentId: student_id,
        enrollmentTerms: enrollment_terms,
      }
    }
  end
  let(:cs_enrollment_terms_requestor) { double(get: cs_enrollment_terms_response) }
  let(:enrollment_term) { double(:enrollment_term, :class => User::Academics::Enrollment::Term) }
  before do
    allow(User::Academics::Enrollment::Term).to receive(:new).and_return(enrollment_term)
    allow(CampusSolutions::EnrollmentTerms).to receive(:new).and_return(cs_enrollment_terms_requestor)
  end
  subject { described_class.new(user) }

  describe '#all' do
    let(:result) { subject.all }
    it 'returns term objects' do
      expect(result.count).to eq 2
      result.each do |term|
        expect(term.class).to eq User::Academics::Enrollment::Term
      end
    end
  end

  describe '#as_json' do
    let(:result) { subject.as_json }
    it 'returns terms as array of hashes' do
      expect(result.count).to eq 2
      result.each do |term_hash|
        expect(term_hash).to be_an_instance_of Hash
      end
    end
  end
end
