describe Api::EnrollmentResources do
  let(:user_id) { '61889' }
  subject { described_class.new(user_id) }
  describe '#as_json' do
    let(:result) { subject.as_json }
    it 'returns json representation of enrollment resources' do
      expect(result).to be_an_instance_of Hash
      expect(result[:links]).to be_an_instance_of Hash
      expect(result[:messages]).to be_an_instance_of Hash
    end
  end
end
