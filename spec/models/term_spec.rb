describe Term do
  let(:now) { DateTime.parse('2020-08-28T09:27:42-07:00') }
  let(:is_summer) { 'N' }
  before { allow(Settings.terms).to receive(:fake_now).and_return(now) }
  subject { build(:term) }

  its(:id) { should eq '2208' }
  its(:type) { should eq 'Fall' }
  its(:year) { should eq '2020' }
  its(:code) { should eq 'D' }
  its(:academic_career_code) { should eq 'UGRD' }
  its(:description) { should eq 'Fall 2020' }
  its(:begin_date) { should eq Time.parse('2020-08-19 00:00:00 UTC') }
  its(:end_date) { should eq Time.parse('2020-12-18 00:00:00 UTC') }
  its(:class_begin_date) { should eq Time.parse('2020-08-26 00:00:00 UTC') }
  its(:class_end_date) { should eq Time.parse('2020-12-11 00:00:00 UTC') }
  its(:instruction_end_date) { should eq Time.parse('2020-12-11 00:00:00 UTC') }
  its(:end_drop_add_date) { should eq Time.parse('2020-09-16 00:00:00 UTC') }
  its(:grades_entered_date) { should eq Time.parse('2020-12-27 00:00:00 UTC') }
  its(:is_summer) { should eq 'N' }

  its(:past?) { should eq false }
  its(:active?) { should eq true }
  its(:past_add_drop?) { should eq false }
  its(:past_classes_start?) { should eq true }
  its(:past_end_of_instruction?) { should eq false }
  its(:past_financial_disbursement?) { should eq true }
  its(:past_grades_entered?) { should eq false }

  describe '#now' do
    let(:result) { subject.now }
    it 'returns the current DateTime' do
      expect(result).to be_an_instance_of DateTime
      expect(result.to_i).to eq 1598632062
    end
  end

  describe '#summer?' do
    context 'when value is \'N\'' do
      subject { build(:term, {is_summer: 'N'}) }
      it 'returns false' do
        expect(subject.summer?).to eq false
      end
    end
    context 'when value is \'Y\'' do
      subject { build(:term, {is_summer: 'Y'}) }
      it 'returns true' do
        expect(subject.summer?).to eq true
      end
    end
  end

  describe '#to_json' do
    let(:json_string) { subject.to_json }
    let(:json_hash) { JSON.parse(json_string) }
    it 'returns JSON representation' do
      expect(json_hash).to be_an_instance_of Hash
      expect(json_hash['id']).to eq '2208'
      expect(json_hash['type']).to eq 'Fall'
      expect(json_hash['year']).to eq '2020'
      expect(json_hash['code']).to eq 'D'
      expect(json_hash['description']).to eq 'Fall 2020'
      expect(json_hash['academic_career_code']).to eq 'UGRD'
      expect(json_hash['begin_date']).to eq '2020-08-19T00:00:00.000Z'
      expect(json_hash['end_date']).to eq '2020-12-18T00:00:00.000Z'
      expect(json_hash['class_begin_date']).to eq '2020-08-26T00:00:00.000Z'
      expect(json_hash['class_end_date']).to eq '2020-12-11T00:00:00.000Z'
      expect(json_hash['instruction_end_date']).to eq '2020-12-11T00:00:00.000Z'
      expect(json_hash['grades_entered_date']).to eq '2020-12-27T00:00:00.000Z'
      expect(json_hash['end_drop_add_date']).to eq '2020-09-16T00:00:00.000Z'
      expect(json_hash['is_summer']).to eq false
    end
  end
end
