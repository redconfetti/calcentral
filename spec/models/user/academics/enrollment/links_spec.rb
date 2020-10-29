describe User::Academics::Enrollment::Links do
  let(:uid) { '61889' }
  let(:user) { User::Current.new(uid) }
  let(:current_academic_roles) { ['lettersAndScience'] }
  let(:user_is_undergraduate) { true }
  before do
    allow(user).to receive(:is_undergrad?).and_return(user_is_undergraduate)
    allow(user).to receive(:current_academic_roles).and_return(current_academic_roles)
  end
  subject { described_class.new(user) }

  describe '#links' do
    let(:result) { subject.links }
    it 'returns link set' do
      expect(result).to be_an_instance_of Hash
      expect(result[:uc_add_class_enrollment]).to be_an_instance_of Hash
      expect(result[:uc_edit_class_enrollment]).to be_an_instance_of Hash
      expect(result[:uc_view_class_enrollment]).to be_an_instance_of Hash
      expect(result[:request_late_class_changes]).to be_an_instance_of Hash
      expect(result[:cross_campus_enroll]).to be_an_instance_of Hash
      expect(result[:late_ugrd_enroll_action]).to eq nil
      puts "result: #{result.inspect}"
    end
  end

  describe '#user_allowed_late_undergraduate_enrollment_action?' do
    let(:result) { subject.user_allowed_late_undergraduate_enrollment_action? }
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
