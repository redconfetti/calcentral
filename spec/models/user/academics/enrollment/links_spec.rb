describe User::Academics::Enrollment::Links do
  let(:uid) { '61889' }
  let(:user) { User::Current.new(uid) }
  let(:current_academic_roles) { ['lettersAndScience'] }
  let(:user_is_undergraduate) { true }
  let(:link_data) do
    {
      urlId: 'CS_LINK_API_ID',
      description: 'Go to Campus Solutions',
      url: 'http://www.example.com/'
    }
  end
  let(:link) { Link.new(link_data) }
  before do
    allow(Links).to receive(:find).and_return(link)
    allow(user).to receive(:undergraduate?).and_return(user_is_undergraduate)
    allow(user).to receive(:current_academic_roles).and_return(current_academic_roles)
  end
  subject { described_class.new(user) }

  describe '#to_json' do
    let(:json_string) { subject.to_json }
    let(:json_hash) { JSON.parse(json_string) }
    it 'returns json representation with camelized keys' do
      expect(json_hash.keys).to eq [
        'ucAddClassEnrollment',
        'ucEditClassEnrollment',
        'ucViewClassEnrollment',
        'requestLateClassChanges',
        'crossCampusEnroll',
        'enrollmentCenter',
        'lateUgrdEnrollAction',
      ]
    end
  end

  describe '#links' do
    let(:result) { subject.links }
    let(:late_enrollment_action_allowed) { true }
    before do
      allow(subject).to receive(:late_undergraduate_enrollment_action_allowed?)
        .and_return(late_enrollment_action_allowed)
    end
    context 'when user is an undergraduate that is allowed to take late enrollment action' do
      let(:late_enrollment_action_allowed) { true }
      it 'does not provide late enrollment action link' do
        expect(result[:late_ugrd_enroll_action]).to be_an_instance_of Link
      end
    end
    context 'when user is not allowed to take late enrollment action' do
      let(:late_enrollment_action_allowed) { false }
      it 'does not provide late enrollment action link' do
        expect(result[:late_ugrd_enroll_action]).to eq nil
      end
    end
    it 'returns link set' do
      expect(result).to be_an_instance_of Hash
      expect(result[:uc_add_class_enrollment]).to be_an_instance_of Link
      expect(result[:uc_edit_class_enrollment]).to be_an_instance_of Link
      expect(result[:uc_view_class_enrollment]).to be_an_instance_of Link
      expect(result[:request_late_class_changes]).to be_an_instance_of Link
      expect(result[:cross_campus_enroll]).to be_an_instance_of Link
      expect(result[:enrollment_center]).to be_an_instance_of Link
    end
  end

  describe 'private methods' do
    describe '#late_undergraduate_enrollment_action_allowed?' do
      let(:result) { subject.send(:late_undergraduate_enrollment_action_allowed?) }
      context 'when user is not an undergradate student' do
        let(:user_is_undergraduate) { false }
        it 'returns false' do
          expect(result).to eq false
        end
      end
      context 'when user is an undergradate student' do
        let(:user_is_undergraduate) { true }
        context 'when user is not allowed to take late enrollment action' do
          let(:current_academic_roles) { ['ugrdNonDegree'] }
          it 'returns false' do
            expect(result).to eq false
          end
        end
        context 'when user is allowed to take late enrollment action' do
          let(:current_academic_roles) { ['ugrdHaasBusiness'] }
          it 'returns true' do
            expect(result).to eq true
          end
        end
      end
    end
  end

end
