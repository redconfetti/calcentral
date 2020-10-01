describe User::Academics::Enrollment::Links do
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
    end
  end
end
