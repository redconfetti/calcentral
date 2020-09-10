describe User::Academics::Enrollment::EnrollmentClass do
  let(:enrollment_attributes) { attributes_for(:user_academics_enrollment_class, :enrollment) }
  subject { described_class.new(enrollment_attributes) }

  its(:type) { should eq :enrollment}
  its(:id) { should eq '23150'}
  its(:career_code) { should eq 'UGRD'}
  its(:career_description) { should eq 'Undergrad'}
  its(:subject_catalog) { should eq 'PHYSICS 8B'}
  its(:title) { should eq 'INTRO PHYSICS'}
  its(:ssr_component_code) { should eq 'DIS'}
  its(:ssr_component_description) { should eq 'Discussion'}
  its(:when) { should eq ['Tu 12:00P-1:59P'] }
  its(:units) { should eq 0.0 }
  its(:edd) { should eq 'Y' }

  describe '#as_json' do
    let(:json_hash) { subject.as_json }
    it 'returns hash for json' do
      expect(json_hash).to be_an_instance_of Hash
      expect(json_hash[:type]).to eq :enrollment
      expect(json_hash[:id]).to eq '23150'
      expect(json_hash[:careerCode]).to eq 'UGRD'
      expect(json_hash[:careerDescription]).to eq 'Undergrad'
      expect(json_hash[:subjectCatalog]).to eq 'PHYSICS 8B'
      expect(json_hash[:title]).to eq 'INTRO PHYSICS'
      expect(json_hash[:ssrComponentCode]).to eq 'DIS'
      expect(json_hash[:ssrComponentDescription]).to eq 'Discussion'
      expect(json_hash[:when][0]).to eq 'Tu 12:00P-1:59P'
      expect(json_hash[:units]).to eq 0.0
      expect(json_hash[:hasEarlyDropDeadline?]).to eq true
    end
  end

  describe '#has_early_drop_deadline?' do
    let(:result) { subject.has_early_drop_deadline? }

    context 'when value is \'Y\'' do
      let(:enrollment_attributes) { attributes_for(:user_academics_enrollment_class, :enrollment, {edd: 'Y'}) }
      it 'returns true' do
        expect(result).to eq true
      end
    end
    context 'when value is not \'Y\'' do
      let(:enrollment_attributes) { attributes_for(:user_academics_enrollment_class, :enrollment, {edd: 'not_Y'}) }
      it 'returns false' do
        expect(result).to eq false
      end
    end
  end
end
