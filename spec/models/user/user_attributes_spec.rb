describe User::UserAttributes do
  subject { described_class.new(user) }
  let(:uid) { random_id }
  let(:user) { User::Current.new(uid) }
  let(:campus_solutions_id) { random_id }
  let(:hub_edos_user_attribute_feed) do
    {
      ldap_uid: uid,
      campus_solutions_id: campus_solutions_id,
      student_id: campus_solutions_id,
      first_name: 'Ziggy',
      last_name: 'Stardust',
      person_name: 'Ziggy Stardust',
      given_name: 'Oski',
      family_name: 'Bear',
      official_bmail_address: 'oski@berkeley.edu',
      email_address: 'oski@gmail.com',
      statusCode: 200,
      roles: edo_roles,
    }
  end
  let(:ldap_attribute_feed) do
    {
      ldap_uid: uid,
      student_id: campus_solutions_id,
      campus_solutions_id: campus_solutions_id,
      email_address: 'oski@berkeley.edu',
      first_name: 'Major',
      last_name: 'Tom',
      person_name: 'Major Tom',
      official_bmail_address: 'oski@berkeley.edu',
      roles: ldap_roles,
    }
  end
  let(:ldap_roles) { Berkeley::UserRoles.base_roles }
  let(:edo_roles) { Berkeley::UserRoles.base_roles }

  let(:hub_edos_user_attributes) { double(get: hub_edos_user_attribute_feed) }
  let(:ldap_attributes) { double(get_feed: ldap_attribute_feed) }
  let(:cs_profile_feature_flag) { true }

  before do
    allow(Settings.features).to receive(:cs_profile).and_return(cs_profile_feature_flag)
    allow(HubEdos::UserAttributes).to receive(:new).and_return(hub_edos_user_attributes)
    allow(CalnetLdap::UserAttributes).to receive(:new).with(user_id: uid).and_return(ldap_attributes)
  end

  describe '#user' do
    it 'returns user' do
      expect(subject.user.uid).to eq uid
    end
  end

  describe '#unknown?' do
    context 'when calnet ldap attributes are not present' do
      let(:ldap_attribute_feed) { {} }
      context 'when campus solutions id is not present' do
        before { allow(subject).to receive(:campus_solutions_id).and_return(nil) }
        it 'returns true' do
          expect(subject.unknown?).to eq true
        end
      end
      context 'when campus solutions id is present' do
        before { allow(subject).to receive(:campus_solutions_id).and_return(campus_solutions_id) }
        it 'returns false' do
          expect(subject.unknown?).to eq false
        end
      end
    end
    context 'when calnet ldap attributes are present' do
      context 'when campus solutions id is not present' do
        before { allow(subject).to receive(:campus_solutions_id).and_return(nil) }
        it 'returns false' do
          expect(subject.unknown?).to eq false
        end
      end
      context 'when campus solutions id is present' do
        before { allow(subject).to receive(:campus_solutions_id).and_return(campus_solutions_id) }
        it 'returns false' do
          expect(subject.unknown?).to eq false
        end
      end
    end
  end

  describe '#campus_solutions_id' do
    it 'returns campus solutions id from edo attributes' do
      expect(subject.campus_solutions_id).to eq campus_solutions_id
    end
  end

  describe '#default_name' do
    it 'returns users preferred name' do
      expect(subject.default_name).to eq 'Major Tom'
    end
  end

  describe '#edo_attributes' do
    let(:result) { subject.edo_attributes }
    context 'when sis profile feature flag turned off' do
      let(:cs_profile_feature_flag) { false }
      it 'returns empty hash' do
        expect(result).to eq({})
      end
    end
    context 'when sis profile feature flag turned on' do
      let(:cs_profile_feature_flag) { true }
      it 'returns attributes hash' do
        expect(result[:ldap_uid]).to eq uid
        expect(result[:campus_solutions_id]).to eq campus_solutions_id
      end
    end
  end

  describe '#edo_roles' do
    let(:result) { subject.edo_roles }
    before { allow(subject).to receive(:edo_attributes).and_return(edo_attributes) }
    context 'when edo roles not present in edo attributes' do
      let(:edo_attributes) { {no_tolls: 'then we don\'t eat no rolls'} }
      it 'returns empty hash' do
        expect(result).to eq({})
      end
    end
    context 'when edo roles are present in edo attributes' do
      let(:edo_attributes) { {roles: {student: true, exStudent: false}} }
      it 'returns roles hash' do
        expect(result[:student]).to eq true
        expect(result[:exStudent]).to eq false
      end
    end
  end

  describe '#roles' do
    let(:result) { subject.roles }
    context 'when ldap roles not present' do
      let(:ldap_attribute_feed) { Hash.new }
      it 'returns all roles as false' do
        expect(result.values.uniq).to eq([false])
      end
    end
    context 'when ldap roles are present' do
      before { ldap_roles[:releasedAdmit] = true }
      context 'when sis profile feature flag turned off' do
        let(:cs_profile_feature_flag) { false }
        it 'returns ldap roles' do
          expect(result[:releasedAdmit]).to eq true
          expect(result[:student]).to eq false
        end
      end
      context 'when sis profile feature flag turned on' do
        let(:cs_profile_feature_flag) { true }
        context 'when edo roles not present' do
          let(:hub_edos_user_attribute_feed) { Hash.new }
          it 'returns ldap roles' do
            expect(result[:releasedAdmit]).to eq true
            expect(result[:student]).to eq false
          end
        end
        context 'when edo roles are present' do
          before { edo_roles[:student] = true }
          it 'indicates true for roles indicated by both ldap and edo' do
            expect(result[:student]).to eq true
            expect(result[:releasedAdmit]).to eq true
          end
        end
        context 'when edo role as student and ldap as ex-student' do
          before do
            edo_roles[:student] = true
            ldap_roles[:exStudent] = true
          end
          it 'indicates the user is a student but not an ex-student' do
            expect(result[:student]).to eq true
            expect(result[:releasedAdmit]).to eq true
            expect(result[:exStudent]).to eq false
          end
        end
      end
    end
  end

  describe '#validate_attribute' do
    let(:result) { subject.validate_attribute(value, format) }
    context 'when format is :string' do
      let(:format) { :string }
      context 'when value is not a string' do
        let(:value) { 123 }
        it 'raises argument error' do
          expect { result }.to raise_error(ArgumentError)
        end
      end
      context 'when value is not present' do
        let(:value) { nil }
        it 'raises argument error' do
          expect { result }.to raise_error(ArgumentError)
        end
      end
      context 'when value is a string' do
        let(:value) { 'abc' }
        it 'returns value' do
          expect(result).to eq 'abc'
        end
      end
    end
    context 'when format is :numeric_string' do
      let(:format) { :numeric_string }
      context 'when value is not a string' do
        let(:value) { [1,2,3] }
        it 'raises argument error' do
          expect { result }.to raise_error(ArgumentError)
        end
      end
      context 'when value is not a numeric string' do
        let(:value) { 'abc' }
        it 'raises argument error' do
          expect { result }.to raise_error(ArgumentError)
        end
      end
      context 'when value is a numeric string' do
        let(:value) { '321' }
        it 'returns value' do
          expect(result).to eq '321'
        end
      end
    end
  end

  describe '#edo_attributes' do
    context 'when cs profile feature flag is disabled' do
      let(:cs_profile_feature_flag) { false }
      it 'returns empty hash' do
        expect(subject.edo_attributes).to eq({})
      end
    end
    context 'when cs profile feature flag is enabled' do
      let(:cs_profile_feature_flag) { true }
      it 'returns attributes' do
        result = subject.edo_attributes
        expect(result).to be_an_instance_of Hash
        expect(result[:ldap_uid]).to eq uid
        expect(result[:campus_solutions_id]).to eq campus_solutions_id
        expect(result[:student_id]).to eq campus_solutions_id
        expect(result[:first_name]).to eq 'Ziggy'
        expect(result[:last_name]).to eq 'Stardust'
      end
    end
  end

  describe '#as_json' do
    it 'returns hash representation' do
      result = subject.as_json
      expect(result).to be_an_instance_of Hash
      expect(result[:ldapUid]).to eq uid
      expect(result[:unknown]).to eq false
      expect(result[:sisProfileVisible]).to eq true
      expect(result[:campusSolutionsId]).to eq campus_solutions_id
      expect(result[:studentId]).to eq campus_solutions_id
      expect(result[:defaultName]).to eq 'Major Tom'
      expect(result[:firstName]).to eq 'Major'
      expect(result[:lastName]).to eq 'Tom'
      expect(result[:givenFirstName]).to eq 'Oski'
      expect(result[:familyName]).to eq 'Bear'
      expect(result[:primaryEmailAddress]).to eq 'oski@berkeley.edu'
      expect(result[:officialBmailAddress]).to eq 'oski@berkeley.edu'
      expect(result[:roles][:advisor]).to eq false
      expect(result[:roles][:faculty]).to eq false
      expect(result[:roles][:student]).to eq false
      expect(result[:roles][:exStudent]).to eq false
      expect(result[:roles][:applicant]).to eq false
      expect(result[:roles][:releasedAdmit]).to eq false
    end
  end
end
