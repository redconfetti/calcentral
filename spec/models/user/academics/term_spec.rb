describe User::Academics::Term do
  let(:term_id) { '2208' }
  let(:now) { DateTime.parse('2020-08-28T09:27:42-07:00') }
  let(:berkeley_time_code) { 'D' }
  let(:berkeley_time_to_english) { 'Fall 2020' }
  let(:berkeley_term_is_summer) { false }
  let(:berkeley_term_year) { 2020 }
  let(:berkeley_term_classes_start) { DateTime.parse('Wed, 26 Aug 2020 00:00:00 -0700') }
  let(:berkeley_term_end_date) { DateTime.parse('2020-12-18T00:00:00-08:00') }
  let(:berkeley_term_end_drop_add_date) { DateTime.parse('2020-09-16 00:00:00 UTC') }
  let(:berkeley_term) do
    double({
      :code => berkeley_time_code,
      :to_english => berkeley_time_to_english,
      :is_summer => berkeley_term_is_summer,
      :end => berkeley_term_end_date,
      :year => berkeley_term_year,
      :classes_start => berkeley_term_classes_start,
      :end_drop_add => berkeley_term_end_drop_add_date,
    })
  end

  before do
    allow(Settings.terms).to receive(:fake_now).and_return(now)
    allow(Berkeley::Terms).to receive(:find).with('2208').and_return(berkeley_term)
  end

  subject { described_class.new(term_id) }

  its(:semester_name) { should eq 'Fall' }
  its(:code) { should eq 'D' }
  its(:name) { should eq 'Fall 2020' }
  its(:summer?) { should eq false }
  its(:past?) { should eq false }
  its(:active?) { should eq true }
  its(:year) { should eq 2020 }
  its(:past_add_drop?) { should eq false }
  its(:past_classes_start?) { should eq true }
  its(:past_end_of_instruction?) { should eq false }
  its(:past_financial_disbursement?) { should eq true }

  describe '#now' do
    let(:result) { subject.now }
    it 'returns the current DateTime' do
      expect(result).to be_an_instance_of DateTime
      expect(result.to_i).to eq 1598632062
    end
  end
end
