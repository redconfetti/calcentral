describe HubEdos::PersonApi::V1::Affiliations do
  let(:admit_affiliation) do
    {
      'type' => {'code' => 'ADMT_UX', 'description' => 'Admitted student\'s access to Cal Central'},
      'detail' => 'Active',
      'status' => admit_affiliation_status,
      'fromDate' => '2018-10-07',
    }
  end
  let(:alum_former_affiliation) do
    {
      'type' => {'code' => 'ALUMFORMER', 'description' => 'Alum/Former Student'},
      'detail' => 'Former Student',
      'status' => alum_former_affiliation_status,
      'fromDate' => '2019-04-12',
    }
  end
  let(:student_affiliation) do
    {
      'type' => {'code' => 'STUDENT'},
      'status' => student_affiliation_status,
      'fromDate' => '2020-05-19',
    }
  end
  let(:active_status) { {'code' => 'ACT', 'description' => 'Active'} }
  let(:inactive_status) { {'code' => 'INA', 'description' => 'Inactive'} }

  let(:admit_affiliation_status) { active_status }
  let(:alum_former_affiliation_status) { active_status }
  let(:student_affiliation_status) { active_status }
  let(:affiliations_data) { [admit_affiliation, alum_former_affiliation] }

  subject { described_class.new(affiliations_data) }

  describe '#all' do
    its('all.count') { should eq(2) }
    it 'should return only affiliation objects' do
      subject.all.each do |identifier|
        expect(identifier).to be_an_instance_of HubEdos::PersonApi::V1::Affiliation
      end
    end
  end

  describe '#active' do
    let(:affiliations_data) { [alum_former_affiliation, admit_affiliation, student_affiliation] }
    let(:admit_affiliation_status) { active_status }
    let(:student_affiliation_status) { active_status }
    let(:alum_former_affiliation_status) { inactive_status }
    it 'should return only active affiliation objects' do
      active_affiliations = subject.active
      expect(active_affiliations.count).to eq 2
      active_affiliations.each {|af| expect(af.is_active?).to eq true }
    end
  end

  describe '#inactive' do
    let(:affiliations_data) { [alum_former_affiliation, admit_affiliation, student_affiliation] }
    let(:admit_affiliation_status) { active_status }
    let(:student_affiliation_status) { active_status }
    let(:alum_former_affiliation_status) { inactive_status }
    it 'should return only inactive affiliation objects' do
      active_affiliations = subject.inactive
      expect(active_affiliations.count).to eq 1
      active_affiliations.each {|af| expect(af.is_inactive?).to eq true }
    end
  end

  describe '#active_admit_affiliation_present?' do
    context 'when collection includes an admit affiliation' do
      let(:affiliations_data) { [admit_affiliation, alum_former_affiliation] }
      context 'when admit affiliation is active' do
        let(:admit_affiliation_status) { active_status }
        it 'returns true' do
          expect(subject.active_admit_affiliation_present?).to eq true
        end
      end
      context 'when admit affiliation is not active' do
        let(:admit_affiliation_status) { inactive_status }
        it 'returns false' do
          expect(subject.active_admit_affiliation_present?).to eq false
        end
      end
    end
    context 'when collection does not include an admit affiliation' do
      let(:affiliations_data) { [student_affiliation, alum_former_affiliation] }
      it 'returns false' do
        expect(subject.active_admit_affiliation_present?).to eq false
      end
    end
  end

  describe '#active_advisor_affiliation_present?' do
    context 'when collection includes an active advisor affiliation' do
      let(:advisor_affiliation) do
        {
          'type' => {'code' => 'ADVISOR'},
          'detail' => 'Active',
          'status' => active_status,
          'fromDate' => '2018-10-07',
        }
      end
      let(:affiliations_data) { [advisor_affiliation, alum_former_affiliation] }
      it 'returns true' do
        expect(subject.active_advisor_affiliation_present?).to eq true
      end
    end
  end

  describe '#inactive_student_affiliation_present?' do
    let(:alum_former_affiliation_status) { active_status }
    let(:inactive_affiliation) do
      {
        'type' => {'code' => inactive_affiliation_code},
        'detail' => 'Active',
        'status' => inactive_status,
        'fromDate' => '2018-10-07',
      }
    end
    let(:affiliations_data) { [inactive_affiliation, alum_former_affiliation] }
    context 'when inactive student affiliation present' do
      let(:inactive_affiliation_code) { 'STUDENT' }
      it 'returns true' do
        expect(subject.inactive_student_affiliation_present?).to eq true
      end
    end
    context 'when inactive undergraduate affiliation present' do
      let(:inactive_affiliation_code) { 'UNDERGRAD' }
      it 'returns true' do
        expect(subject.inactive_student_affiliation_present?).to eq true
      end
    end
    context 'when inactive graduate affiliation present' do
      let(:inactive_affiliation_code) { 'GRADUATE' }
      it 'returns true' do
        expect(subject.inactive_student_affiliation_present?).to eq true
      end
    end
    context 'when no student affiliations are present' do
      let(:inactive_affiliation_code) { 'ADVISOR' }
      it 'returns false' do
        expect(subject.inactive_student_affiliation_present?).to eq false
      end
    end
  end

  describe '#active_student_affiliation_present?' do
    context 'when collection includes a student affiliation' do
      let(:affiliations_data) { [admit_affiliation, student_affiliation] }
      context 'when student affiliation is active' do
        let(:student_affiliation_status) { active_status }
        it 'returns true' do
          expect(subject.active_student_affiliation_present?).to eq true
        end
      end
      context 'when student affiliation is not active' do
        let(:student_affiliation_status) { inactive_status }
        it 'returns false' do
          expect(subject.active_student_affiliation_present?).to eq false
        end
      end
    end
    context 'when collection does not include a student affiliation' do
      let(:affiliations_data) { [admit_affiliation, alum_former_affiliation] }
      it 'returns false' do
        expect(subject.active_student_affiliation_present?).to eq false
      end
    end
  end

  describe '#matriculated_but_excluded?' do
    let(:affiliation_1) { double('affiliation_1', :matriculated_but_excluded? => false) }
    let(:affiliation_2) { double('affiliation_2', :matriculated_but_excluded? => true) }
    let(:affiliations) { [affiliation_1, affiliation_2] }
    let(:result) { subject.matriculated_but_excluded? }
    before do
      allow(subject).to receive(:all).and_return(affiliations)
    end
    context 'when matriculated but excluded affiliation present' do
      let(:affiliations) { [affiliation_1, affiliation_2] }
      it 'returns true' do
        expect(result).to eq true
      end
    end
    context 'when matriculated but excluded affiliation is not present' do
      let(:affiliations) { [affiliation_1] }
      it 'returns false' do
        expect(result).to eq false
      end
    end
  end
end
