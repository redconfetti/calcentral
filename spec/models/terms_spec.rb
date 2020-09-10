describe Terms do
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
      'is_summer' => 'N'
    }
  end
  let(:cached_terms) { [fall_2020_term] }
  let(:cached_terms_provider) { double(get: cached_terms) }
  before do
    allow(Cached::Terms).to receive(:new).and_return(cached_terms_provider)
  end

  describe '.find_undergraduate' do
    let(:term_id) { '2208' }
    let(:result) { described_class.find_undergraduate(term_id) }
    context 'when multiple terms present' do
      let(:summer_2020_term) { {'id' => '2205'} }
      let(:fall_2020_term) { {'id' => '2208'} }
      let(:spring_2021_term) { {'id' => '2212'} }
      let(:cached_terms) { [summer_2020_term, fall_2020_term, spring_2021_term] }
      it 'returns term matching id' do
        expect(result).to be_an_instance_of Term
        expect(result.id).to eq '2208'
      end
    end
  end

  describe '.all' do
    let(:result) { described_class.all }
    it 'returns all terms' do
      expect(result).to be_an_instance_of Array
      expect(result.count).to eq 1
      expect(result[0].id).to eq '2208'
    end
  end

  describe '.undergraduate' do
    let(:fall_2020_term_ugrd) { {'id' => '2208', 'career_code' => 'UGRD'} }
    let(:fall_2020_term_grad) { {'id' => '2208', 'career_code' => 'GRAD'} }
    let(:cached_terms) { [fall_2020_term_ugrd, fall_2020_term_grad] }
    let(:result) { described_class.undergraduate }
    it 'returns all undergraduate terms' do
      expect(result).to be_an_instance_of Array
      expect(result.count).to eq 1
      expect(result[0].id).to eq '2208'
      expect(result[0].career_code).to eq 'UGRD'
    end
  end
end
