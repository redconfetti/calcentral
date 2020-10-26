describe HubEdos::PersonApi::V1::Affiliation do
  let(:type_code) { 'ALUMFORMER' }
  let(:detail) { 'Former Student' }
  let(:attributes) do
    {
      'type' => {
        'code' => type_code,
        'description' => 'Alum/Former Student',
      },
      'detail' => detail,
      'status' => status,
      "fromDate" => "2019-04-12",
    }
  end
  let(:status) { active_status }
  let(:active_status) { {'code' => 'ACT', 'description' => 'Active'} }
  let(:inactive_status) { {'code' => 'INA', 'description' => 'Inactive'} }
  subject { described_class.new(attributes) }
  its('type.code') { should eq('ALUMFORMER') }
  its(:from_date) { should be_an_instance_of(Date) }
  its('from_date.to_s') { should eq('2019-04-12') }

  describe '#matriculated_but_excluded?' do
    let(:result) { subject.matriculated_but_excluded? }
    context 'when affiliation is not an applicant' do
      let(:type_code) { 'ALUMFORMER' }
      it 'returns false' do
        expect(result).to eq false
      end
    end
    context 'when affiliation is an applicant' do
      let(:type_code) { 'APPLICANT' }
      context 'when detail indicates SIR completed' do
        let(:detail) { 'SIR Completed' }
        it 'returns true' do
          expect(result).to eq true
        end
      end
      context 'when detail indicates deposit pending' do
        let(:detail) { 'Deposit Pending' }
        it 'returns true' do
          expect(result).to eq true
        end
      end
      context 'when detail not indicating matriculation' do
        let(:detail) { 'Active' }
        it 'returns false' do
          expect(result).to eq false
        end
      end
    end
  end

  describe '#is_active?' do
    context 'when affiliation is active' do
      let(:status) { active_status }
      it 'returns true' do
        expect(subject.is_active?).to eq true
      end
    end
    context 'when affiliation is not active' do
      let(:status) { inactive_status }
      it 'returns false' do
        expect(subject.is_active?).to eq false
      end
    end
  end

  describe '#is_inactive?' do
    context 'when affiliation is not active' do
      let(:status) { inactive_status }
      it 'returns true' do
        expect(subject.is_inactive?).to eq true
      end
    end
    context 'when affiliation is active' do
      let(:status) { active_status }
      it 'returns false' do
        expect(subject.is_inactive?).to eq false
      end
    end
  end

  describe '#is_student?' do
    context 'when type code is \'STUDENT\'' do
      let(:type_code) { 'STUDENT' }
      it 'returns true' do
        expect(subject.is_student?).to eq true
      end
    end
    context 'when type code is not \'STUDENT\'' do
      let(:type_code) { 'ALUMFORMER' }
      it 'returns false' do
        expect(subject.is_student?).to eq false
      end
    end
  end

  describe '#is_graduate?' do
    context 'when type code is \'GRADUATE\'' do
      let(:type_code) { 'GRADUATE' }
      it 'returns true' do
        expect(subject.is_graduate?).to eq true
      end
    end
    context 'when type code is not \'GRADUATE\'' do
      let(:type_code) { 'UNDERGRAD' }
      it 'returns false' do
        expect(subject.is_graduate?).to eq false
      end
    end
  end

  describe '#is_law?' do
    context 'when type code is \'LAW\'' do
      let(:type_code) { 'LAW' }
      it 'returns true' do
        expect(subject.is_law?).to eq true
      end
    end
    context 'when type code is not \'LAW\'' do
      let(:type_code) { 'UNDERGRAD' }
      it 'returns false' do
        expect(subject.is_law?).to eq false
      end
    end
  end

  describe '#is_uc_extension?' do
    context 'when type code is \'EXTENSION\'' do
      let(:type_code) { 'EXTENSION' }
      it 'returns true' do
        expect(subject.is_uc_extension?).to eq true
      end
    end
    context 'when type code is not \'EXTENSION\'' do
      let(:type_code) { 'GRADUATE' }
      it 'returns false' do
        expect(subject.is_uc_extension?).to eq false
      end
    end
  end


  describe '#is_undergraduate?' do
    context 'when type code is \'UNDERGRAD\'' do
      let(:type_code) { 'UNDERGRAD' }
      it 'returns true' do
        expect(subject.is_undergraduate?).to eq true
      end
    end
    context 'when type code is not \'UNDERGRAD\'' do
      let(:type_code) { 'GRADUATE' }
      it 'returns false' do
        expect(subject.is_undergraduate?).to eq false
      end
    end
  end

  describe '#is_advisor?' do
    context 'when type code is \'ADVISOR\'' do
      let(:type_code) { 'ADVISOR' }
      it 'returns true' do
        expect(subject.is_advisor?).to eq true
      end
    end
    context 'when type code is not \'ADVISOR\'' do
      let(:type_code) { 'GRADUATE' }
      it 'returns false' do
        expect(subject.is_advisor?).to eq false
      end
    end
  end

  describe '#is_admit_ux?' do
    context 'when type code is \'ADMT_UX\'' do
      let(:type_code) { 'ADMT_UX' }
      it 'returns true' do
        expect(subject.is_admit_ux?).to eq true
      end
    end
    context 'when type code is not \'ADMT_UX\'' do
      let(:type_code) { 'ALUMFORMER' }
      it 'returns false' do
        expect(subject.is_admit_ux?).to eq false
      end
    end
  end

  describe '#is_applicant?' do
    context 'when type code is \'APPLICANT\'' do
      let(:type_code) { 'APPLICANT' }
      context 'when detail is \'Applied\'' do
        let(:detail) { 'Applied' }
        it 'returns true' do
          expect(subject.is_applicant?).to eq true
        end
      end
      context 'when detail is not \'Applied\'' do
        let(:detail) { 'Admitted' }
        it 'returns false' do
          expect(subject.is_applicant?).to eq false
        end
      end
    end
    context 'when type code is not \'APPLICANT\'' do
      let(:type_code) { 'ALUMFORMER' }
      it 'returns false' do
        expect(subject.is_applicant?).to eq false
      end
    end
  end

  describe '#is_pre_sir?' do
    context 'when type code is \'APPLICANT\'' do
      let(:type_code) { 'APPLICANT' }
      context 'when detail is \'Admitted\'' do
        let(:detail) { 'Admitted' }
        it 'returns true' do
          expect(subject.is_pre_sir?).to eq true
        end
      end
      context 'when detail is not \'Admitted\'' do
        let(:detail) { 'Applied' }
        it 'returns false' do
          expect(subject.is_pre_sir?).to eq false
        end
      end
    end
    context 'when type code is not \'APPLICANT\'' do
      let(:type_code) { 'ALUMFORMER' }
      it 'returns false' do
        expect(subject.is_pre_sir?).to eq false
      end
    end
  end

  describe '#to_json' do
    it 'returns expected json' do
      json = subject.to_json
      hash_result = JSON.parse(json)
      expect(hash_result['type']['code']).to eq 'ALUMFORMER'
      expect(hash_result['type']['description']).to eq 'Alum/Former Student'
      expect(hash_result['detail']).to eq 'Former Student'
      expect(hash_result['status']['code']).to eq 'ACT'
      expect(hash_result['status']['description']).to eq 'Active'
      expect(hash_result['fromDate']).to eq '2019-04-12'
    end
  end
end
