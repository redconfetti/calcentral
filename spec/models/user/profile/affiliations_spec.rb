describe User::Profile::Affiliations do
  let(:uid) { '61889' }
  let(:user) { double(:uid => uid) }
  subject { described_class.new(user)}

  let(:ldap_affiliations) { ['STUDENT-TYPE-REGISTERED'] }
  let(:calnet_ldap_person) { double(affiliations: ldap_affiliations) }

  before do
    allow(CalnetLdap::Person).to receive(:get).with(user).and_return(calnet_ldap_person)
  end

  its(:not_registered?) { should eq false }
  its(:released_admit?) { should eq true }
  its(:advisor?) { should eq false }
  its(:applicant?) { should eq false }
  its(:graduate?) { should eq false }
  its(:law_student?) { should eq false }
  its(:pre_sir?) { should eq false }
  its(:student?) { should eq false }
  its(:ex_student?) { should eq false }
  its(:uc_extension_student?) { should eq false }
  its(:undergraduate?) { should eq false }

  describe 'not_registered?' do
    context 'when student is registered' do
      let(:ldap_affiliations) { ['STUDENT-TYPE-REGISTERED'] }
      it 'returns false' do
        expect(subject.not_registered?).to eq false
      end
    end
    context 'when student is not registered' do
      let(:ldap_affiliations) { ['STUDENT-TYPE-NOT REGISTERED'] }
      it 'returns true' do
        expect(subject.not_registered?).to eq true
      end
    end
  end
end
