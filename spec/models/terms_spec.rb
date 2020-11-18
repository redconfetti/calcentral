describe ::Terms do
  let(:fall_2020_term) { attributes_for(:term) }
  let(:cached_terms) { [fall_2020_term] }
  let(:cached_terms_provider) { double(get: cached_terms) }
  before do
    allow(::Cached::Terms).to receive(:new).and_return(cached_terms_provider)
  end

  describe 'LEGACY_CODES' do
    it 'defines proper legacy term codes' do
      expect(described_class::LEGACY_CODES['B']).to eq 'Spring'
      expect(described_class::LEGACY_CODES['C']).to eq 'Summer'
      expect(described_class::LEGACY_CODES['D']).to eq 'Fall'
    end
  end

  describe '.find_undergraduate' do
    let(:term_id) { '2208' }
    let(:result) { described_class.find_undergraduate(term_id) }
    context 'when multiple terms present' do
      let(:summer_2020_term) { attributes_for(:term, {'id' => '2208', 'academic_career_code' => 'UGRD'}) }
      let(:fall_2020_term) { attributes_for(:term, {'id' => '2208', 'academic_career_code' => 'UGRD'}) }
      let(:spring_2021_term) { attributes_for(:term, {'id' => '2212', 'academic_career_code' => 'UGRD'}) }
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
    let(:result) { described_class.undergraduate }
    context 'when non-undergraduate terms present for the same semester' do
      let(:fall_2020_term_ugrd) { attributes_for(:term, :undergraduate) }
      let(:fall_2020_term_grad) { attributes_for(:term, :graduate) }
      let(:cached_terms) { [fall_2020_term_ugrd, fall_2020_term_grad] }
      it 'returns only the undergraduate terms' do
        expect(result).to be_an_instance_of Array
        expect(result.count).to eq 1
        expect(result[0].id).to eq '2208'
        expect(result[0].academic_career_code).to eq 'UGRD'
      end
    end
  end
end
