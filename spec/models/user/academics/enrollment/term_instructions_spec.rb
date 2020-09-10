describe User::Academics::Enrollment::TermInstructions do
  let(:user) do
    double(:user, {
      :uid => '61889',
      :enrollment_terms => enrollment_terms,
    })
  end
  let(:term_id_spring_2021) { '2212' }
  let(:term_id_summer_2021) { '2215' }
  let(:enrollment_term_spring_2021) { double(:enrollment_term, term_id: term_id_spring_2021) }
  let(:enrollment_term_summer_2021) { double(:enrollment_term, term_id: term_id_summer_2021) }
  let(:enrollment_terms) { double(:enrollment_terms, all: [enrollment_term_spring_2021, enrollment_term_summer_2021]) }
  before { allow(::User::Academics::Enrollment::Terms).to receive(:new).and_return(enrollment_terms) }

  subject { described_class.new(user) }

  describe '#all' do
    let(:result) { subject.all }
    it 'returns enrollment term instructions for each active enrollment term id' do
      expect(result).to be_an_instance_of Array
      expect(result.count).to eq 2
      expect(result[0]).to be_an_instance_of ::User::Academics::Enrollment::TermInstruction
      expect(result[1]).to be_an_instance_of ::User::Academics::Enrollment::TermInstruction
    end
  end

  describe '#find_by_term_id' do
    let(:term_id) { '2215' }
    let(:result) { subject.find_by_term_id(term_id) }
    it 'returns single term instruction matching id' do
      expect(result.term_id).to eq term_id
    end
  end
end
