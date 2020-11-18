describe User::Academics::Enrollment::Date do
  subject { build(:user_academics_enrollment_date) }

  describe '.from_unix_timestamp' do
    let(:date) { described_class.from_unix_timestamp(1586806200) }
    it 'initalizes object from unix timestamp' do
      expect(date).to be_an_instance_of described_class
      expect(date.unix_timestamp).to eq 1586806200
      expect(date.utc).to eq '2020-04-13T19:30:00+00:00'
    end
  end

  describe '.from_iso_8601' do
    let(:date) { described_class.from_iso_8601('2020-04-13T12:30:00-07:00') }
    it 'initalizes object from unix timestamp' do
      expect(date).to be_an_instance_of described_class
      expect(date.unix_timestamp).to eq 1586806200
      expect(date.utc).to eq '2020-04-13T19:30:00+00:00'
    end
  end

  describe '#date_time' do
    let(:date_time) { subject.date_time }
    it 'returns expected DateTime object' do
      expect(date_time).to be_an_instance_of DateTime
      expect(date_time.to_i).to eq 1586806200
    end
  end

  describe 'utc' do
    it 'returns datetime in UTC ISO 8601 format' do
      expect(subject.utc).to eq '2020-04-13T19:30:00+00:00'
    end
  end

  describe 'pacific' do
    it 'returns datetime in Pacific Timezone ISO 8601 format' do
      expect(subject.pacific).to eq '2020-04-13T12:30:00-07:00'
    end
  end

  describe '#to_json' do
    let(:json_string) { subject.to_json }
    let(:json_hash) { JSON.parse(json_string) }
    it 'returns json representation' do
      expect(json_hash).to be_an_instance_of Hash
      expect(json_hash['unixTimestamp']).to eq 1586806200
      expect(json_hash['utc']).to eq '2020-04-13T19:30:00+00:00'
      expect(json_hash['pacific']).to eq '2020-04-13T12:30:00-07:00'
    end
  end
end
