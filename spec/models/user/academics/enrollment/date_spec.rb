describe User::Academics::Enrollment::Date do
  let(:unix_timestamp) { 1586806200 }
  let(:iso_8601_string) { '2020-04-13T12:30:00-07:00' }
  let(:date_data) { {epoch: unix_timestamp} }

  subject { described_class.new(date_data) }

  it 'raises exception when initialiezd without epoch or iso_8601_string' do
    expected_error_message = 'Options must specify value for :epoch or :iso_8601_string'
    expect { described_class.new(nil) }.to raise_error(RuntimeError, expected_error_message)
    expect { described_class.new({epoch: nil}) }.to raise_error(RuntimeError, expected_error_message)
    expect { described_class.new({iso_8601_string: nil}) }.to raise_error(RuntimeError, expected_error_message)
  end

  describe '#date_time' do
    let(:date_time) { subject.date_time }
    context 'when initalized with unix timestamp (epoch)' do
      let(:date_data) { {epoch: unix_timestamp} }
      it 'returns expected DateTime object' do
        expect(date_time).to be_an_instance_of DateTime
        expect(date_time.to_i).to eq 1586806200
      end
    end
    context 'when initalized with ISO 8601 date/time string' do
      let(:date_data) { {iso_8601_string: iso_8601_string} }
      it 'returns expected DateTime object' do
        expect(date_time).to be_an_instance_of DateTime
        expect(date_time.to_i).to eq 1586806200
      end
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
      expect(json_hash['epoch']).to eq unix_timestamp
      expect(json_hash['utc']).to eq '2020-04-13T19:30:00+00:00'
      expect(json_hash['pacific']).to eq '2020-04-13T12:30:00-07:00'
    end
  end
end
