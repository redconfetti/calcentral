describe User::Academics::Enrollment::Period do
  let(:period_attributes) do
    {
      id: 'PRI1',
      name: 'Phase 1 Begins',
      enddatetime: '2020-06-12T23:59:00',
      acadCareer: 'UGRD',
      date: {
        epoch: 1586806200,
        datetime: '2020-04-13T12:30:00-07:00',
        datestring: '4/13'
      }
    }
  end
  subject { described_class.new(period_attributes) }

  its(:id) { should eq 'PRI1' }
  its(:name) { should eq 'Phase 1 Begins' }
  its(:career) { should eq 'UGRD' }
  its(:enddatetime) { should eq '2020-06-12T23:59:00' }

  describe '#date' do
    it 'returns date hash' do
      expect(subject.date[:epoch]).to eq 1586806200
      expect(subject.date[:datetime]).to eq '2020-04-13T12:30:00-07:00'
      expect(subject.date[:datestring]).to eq '4/13'
    end
  end

  describe '#as_json' do
    let(:json_hash) { subject.as_json }
    it 'returns hash representation for json' do
      expect(json_hash).to be_an_instance_of Hash
      expect(json_hash[:id]).to eq 'PRI1'
      expect(json_hash[:acadCareer]).to eq 'UGRD'
      expect(json_hash[:enddatetime]).to eq '2020-06-12T23:59:00'
      expect(json_hash[:name]).to eq 'Phase 1 Begins'
      expect(json_hash[:date][:epoch]).to eq 1586806200
      expect(json_hash[:date][:datetime]).to eq '2020-04-13T12:30:00-07:00'
      expect(json_hash[:date][:datestring]).to eq '4/13'
    end
  end
end
