describe Term do
  let(:fall_2020_term) do
    {
      'id' => '2208',
      'descr' => 'Fall 2020',
      'type' => 'Fall',
      'year' => '2020',
      'code' => 'D',
      'career_code' => 'UGRD',
      'begin_date' => Time.parse('2020-08-19 00:00:00 UTC'),
      'end_date' => Time.parse('2020-12-18 00:00:00 UTC'),
      'class_begin_date' => Time.parse('2020-08-26 00:00:00 UTC'),
      'class_end_date' => Time.parse('2020-12-11 00:00:00 UTC'),
      'instruction_end_date' => Time.parse('2020-12-11 00:00:00 UTC'),
      'grades_entered_date' => nil,
      'end_drop_add_date' => Time.parse('2020-09-16 00:00:00 UTC'),
      'is_summer' => is_summer
    }
  end
  let(:is_summer) { 'N' }
  subject { described_class.new(fall_2020_term) }

  its(:id) { should eq '2208' }
  its(:year) { should eq '2020' }
  its(:career_code) { should eq 'UGRD' }
  its(:semester_name) { should eq 'Fall' }

  describe '#summer?' do
    context 'when value is \'N\'' do
      let(:is_summer) { 'N' }
      it 'returns false' do
        expect(subject.summer?).to eq false
      end
    end
    context 'when value is \'Y\'' do
      let(:is_summer) { 'Y' }
      it 'returns true' do
        expect(subject.summer?).to eq true
      end
    end
  end
end
