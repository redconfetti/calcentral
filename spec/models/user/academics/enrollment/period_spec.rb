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
        datestring: '4/13',
        offset: '-0700'
      }
    }
  end
  subject { described_class.new(period_attributes) }

  its(:id) { should eq 'PRI1' }
  its(:name) { should eq 'Phase 1 Begins' }
  its(:career) { should eq 'UGRD' }

  describe '#begin_time' do
    it 'returns date object' do
      expect(subject.begin_time).to be_an_instance_of User::Academics::Enrollment::Date
      expect(subject.begin_time.utc).to eq '2020-04-13T19:30:00+00:00'
      expect(subject.begin_time.pacific).to eq '2020-04-13T12:30:00-07:00'
    end
  end

  describe '#end_time' do
    it 'returns date object' do
      expect(subject.end_time).to be_an_instance_of User::Academics::Enrollment::Date
      expect(subject.end_time.utc).to eq '2020-06-12T23:59:00+00:00'
      expect(subject.end_time.pacific).to eq '2020-06-12T16:59:00-07:00'
    end
  end

  describe '#to_json' do
    let(:json_string) { subject.to_json }
    let(:json_hash) { JSON.parse(json_string) }
    it 'returns hash representation for json' do
      expect(json_hash).to be_an_instance_of Hash
      expect(json_hash['id']).to eq 'PRI1'
      expect(json_hash['acadCareer']).to eq 'UGRD'
      expect(json_hash['name']).to eq 'Phase 1 Begins'
      expect(json_hash['beginTime']['epoch']).to eq 1586806200
      expect(json_hash['beginTime']['utc']).to eq '2020-04-13T19:30:00+00:00'
      expect(json_hash['beginTime']['pacific']).to eq '2020-04-13T12:30:00-07:00'
      expect(json_hash['endTime']['epoch']).to eq 1592006340
      expect(json_hash['endTime']['utc']).to eq '2020-06-12T23:59:00+00:00'
      expect(json_hash['endTime']['pacific']).to eq '2020-06-12T16:59:00-07:00'
    end
  end
end
