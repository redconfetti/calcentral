describe HubEdoController do
  before { allow(Settings.hub_edos_proxy).to receive(:fake).and_return true }
  let(:user_id) { random_id }

  describe '#work_experience' do
    let(:feed) { :work_experience }

    it_behaves_like 'an unauthenticated user'

    context 'authenticated user' do
      let(:feed_path) { ['feed','workExperiences'] }
      it_behaves_like 'a successful feed'
    end
  end
end
