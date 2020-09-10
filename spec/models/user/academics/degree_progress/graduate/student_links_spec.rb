describe User::Academics::DegreeProgress::Graduate::StudentLinks do
  subject { described_class.new(user) }
  let(:uid) { '61889' }
  let(:user) { User::Current.new(uid) }
  let(:current_academic_roles) { [] }
  before { allow(user).to receive(:current_academic_roles).and_return(current_academic_roles) }

  describe '#links' do
    let(:apr_law_student) { false }
    let(:apr_grad_student) { false }
    before do
      allow(subject).to receive(:apr_law_student?).and_return(apr_law_student)
      allow(subject).to receive(:apr_grad_student?).and_return(apr_grad_student)
    end
    context 'when student can view law student apr link' do
      let(:apr_law_student) { true }
      it 'returns haas APR link' do
        expect(subject.links[:academic_progress_report_law]).to be
        expect(subject.links[:academic_progress_report_grad]).to_not be
      end
    end
    context 'when student can view grad student apr link' do
      let(:apr_grad_student) { true }
      it 'returns haas APR link' do
        expect(subject.links[:academic_progress_report_law]).to_not be
        expect(subject.links[:academic_progress_report_grad]).to be
      end
    end

  end

  describe '#apr_law_student?' do
    context 'when user is currently an active doctor science law student' do
      let(:current_academic_roles) { [:doctorScienceLaw, :grad] }
      it 'returns true' do
        expect(subject.apr_law_student?).to eq true
      end
    end
    context 'when user is currently an active juris social policy masters student' do
      let(:current_academic_roles) { [:jurisSocialPolicyMasters, :grad] }
      it 'returns true' do
        expect(subject.apr_law_student?).to eq true
      end
    end
    context 'when user is currently an active juris social policy phc student' do
      let(:current_academic_roles) { [:jurisSocialPolicyPhC, :grad] }
      it 'returns true' do
        expect(subject.apr_law_student?).to eq true
      end
    end
    context 'when user is currently an active juris social policy phd student' do
      let(:current_academic_roles) { [:jurisSocialPolicyPhD, :grad] }
      it 'returns true' do
        expect(subject.apr_law_student?).to eq true
      end
    end
    context 'when user is currently an active Law JD/CDP student' do
      let(:current_academic_roles) { [:lawJdCdp, :grad] }
      it 'returns true' do
        expect(subject.apr_law_student?).to eq true
      end
    end
    context 'when user is currently an active Master of Laws LLM student' do
      let(:current_academic_roles) { [:masterOfLawsLlm, :grad] }
      it 'returns true' do
        expect(subject.apr_law_student?).to eq true
      end
    end
    context 'when user is not a law student' do
      let(:current_academic_roles) { [:grad] }
      it 'returns false' do
        expect(subject.apr_law_student?).to eq false
      end
    end
  end
end
