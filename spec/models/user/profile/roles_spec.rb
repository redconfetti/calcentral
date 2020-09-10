describe User::Profile::Roles do
  let(:uid) { '61889' }
  let(:user) { User::Current.new(uid) }
  subject { described_class.new(user) }

  describe 'LABELS' do
    let(:labels) { User::Profile::Roles::LABELS }
    it 'defines labels' do
      expect(labels).to be_an_instance_of Array
      labels.each {|label| expect(label).to be_an_instance_of Symbol }
    end
  end

  describe '.active_roles' do
    let(:legacy_roles_hash) { {student: true, undergrad: true, graduate: false, law: false} }
    let(:result) { described_class.active_roles(legacy_roles_hash) }
    it 'returns array of applicable symbols' do
      expect(result).to be_an_instance_of Array
      expect(result[0]).to eq :student
      expect(result[1]).to eq :undergrad
    end
  end

  describe '.default_roles_hash' do
    let(:result) { described_class.default_roles_hash }
    it 'returns legacy roles hash' do
      expect(result).to be_an_instance_of Hash
      expect(result[:advisor]).to eq false
      expect(result[:applicant]).to eq false
      expect(result[:concurrentEnrollmentStudent]).to eq false
      expect(result[:expiredAccount]).to eq false
      expect(result[:exStudent]).to eq false
      expect(result[:faculty]).to eq false
      expect(result[:graduate]).to eq false
      expect(result[:guest]).to eq false
      expect(result[:law]).to eq false
      expect(result[:registered]).to eq false
      expect(result[:releasedAdmit]).to eq false
      expect(result[:staff]).to eq false
      expect(result[:student]).to eq false
      expect(result[:undergrad]).to eq false
      expect(result[:withdrawnAdmit]).to eq false
      expect(result[:preSir]).to eq false
    end
  end

  describe '#unreleased_applicant?' do
    let(:legacy_cs_roles_hash) do
      {
        applicant: is_applicant,
        preSir: true,
        student: is_student
      }
    end
    let(:is_student) { false }
    before { allow(subject).to receive(:cs_roles).and_return(legacy_cs_roles_hash) }
    context 'when user is not an applicant' do
      let(:is_applicant) { false }
      it 'returns false' do
        expect(subject.unreleased_applicant?).to eq false
      end
    end
    context 'when user is an applicant' do
      let(:is_applicant) { true }
      context 'when user has role other than presir' do
        let(:is_student) { true }
        it 'returns false' do
          expect(subject.unreleased_applicant?).to eq false
        end
      end
      context 'when user has no other roles other than presir' do
        let(:is_student) { false }
        it 'returns true' do
          expect(subject.unreleased_applicant?).to eq true
        end
      end
    end
  end

end
