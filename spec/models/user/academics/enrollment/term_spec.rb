describe User::Academics::Enrollment::Term do
  let(:uid) { '61889' }
  let(:user) { User::Current.new(uid) }
  let(:attributes) do
    {
      termId: '2212',
      termDescr: '2021 Spring',
      acadCareer: 'UGRD',
      user: user
    }
  end

  subject { described_class.new(attributes) }

  its(:term_id) { should eq '2212' }
  its(:description) { should eq '2021 Spring' }
  its(:acad_career) { should eq 'UGRD' }

  describe '#to_json' do
    let(:result) { subject.to_json }
    let(:json) { JSON.parse(result) }
    it 'returns hash representation of enrollment term' do
      expect(json).to be_an_instance_of Hash
      expect(json['termId']).to eq '2212'
      expect(json['academicCareerCode']).to eq 'UGRD'
      expect(json['description']).to eq '2021 Spring'
    end
  end

end
