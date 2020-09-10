describe User::Academics::Enrollment::Careers do
  let(:enrollment_careers_data) { [{acadCareer: 'UGRD'}, {acadCareer: 'GRAD'}] }
  before do
    allow(::User::Academics::Enrollment::Career).to receive(:new) do |data|
      double(:academic_career_code => data[:acadCareer])
    end
  end
  subject { described_class.new(enrollment_careers_data) }

  describe '#all' do
    let(:all_careers) { subject.all }
    it 'returns array of all enrollment career objects' do
      expect(all_careers).to be_an_instance_of Array
      expect(all_careers.count).to eq 2
      expect(all_careers[0].academic_career_code).to eq 'UGRD'
      expect(all_careers[1].academic_career_code).to eq 'GRAD'
    end
  end

  describe '#find_by_career_code' do
    let(:academic_career_code) { 'UGRD' }
    let(:found_career) { subject.find_by_career_code(academic_career_code) }
    it 'returns single career matching specified career code' do
      expect(found_career.academic_career_code).to eq 'UGRD'
    end
  end
end
