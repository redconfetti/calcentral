describe User::Academics::Enrollment::TermPlan do
  let(:term_plan_term_id) { '2208' }
  let(:term_plan_career_code) { 'UGRD' }
  let(:term_plan_program_code) { 'UNODG' }
  let(:term_plan_plan_code) { '09V00U' }
  let(:term_plan_data) do
    {
      'term_id' => term_plan_term_id,
      'acad_career' => term_plan_career_code,
      'acad_program' => term_plan_program_code,
      'acad_plan' => term_plan_plan_code,
    }
  end
  let(:term_plan) do
    User::Academics::TermPlans::TermPlan.new(term_plan_data)
  end

  subject { described_class.new(term_plan) }

  its(:term_id) { should eq term_plan_term_id }
  its(:academic_career_code) { should eq term_plan_career_code }

  describe '#design' do
    context 'when UCBX career role applies to term plan' do
      let(:term_plan_career_code) { 'UCBX' }
      it 'returns \'concurrent\'' do
        expect(subject.design).to eq 'concurrent'
      end
    end

    context 'when career role applies to term plan' do
      let(:term_plan_career_code) { 'LAW' }
      it 'returns career role code' do
        expect(subject.design).to eq 'law'
      end
      context 'when plan role applies to term plan' do
        let(:term_plan_plan_code) { '25000FPFU' }
        it 'returns plan role' do
          expect(subject.design).to eq 'fpf'
        end
      end
    end

    context 'when no career or plan roles apply to term plan' do
      let(:term_plan_career_code) { 'UGRD' }
      let(:term_plan_plan_code) { '25000U' }
      it 'returns \'default\'' do
        expect(subject.design).to eq 'default'
      end
    end
  end

  describe '#to_json' do
    let(:json_result) { subject.to_json }
    let(:json_hash) { JSON.parse(json_result) }
    it 'returns JSON representation' do
      expect(json_hash['design']).to eq 'default'
      expect(json_hash['termId']).to eq '2208'
      expect(json_hash['academicCareerCode']).to eq 'UGRD'
      expect(json_hash['academicProgramCode']).to eq 'UNODG'
      expect(json_hash['academicPlanCode']).to eq '09V00U'
    end
  end
end
