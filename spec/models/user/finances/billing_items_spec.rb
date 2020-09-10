describe User::Finances::BillingItems do
  let(:uid) { '61898' }
  let(:user) { User::Current.new(uid) }
  let(:transactions_data) do
    [
      {
        'term_id' => '2205',
        'amount' => 0,
        'balance' => 0,
        'amount_due' => 0,
        'transaction_number' => ' ',
        'payment_id' => 0,
        'type_code' => 'C',
        'due_date' => Time.parse('2020-07-10 00:00:00 UTC'),
        'original_item_amount' => 349,
        'updated_on' => Time.parse('2020-07-10 00:00:00 UTC'),
        'business_unit' => 'UCB01',
        'common_id' => '11667051',
        'item_id' => '000000000000097',
        'sequence_id' => 2,
        'sequence_amount' => -349,
        'sequence_posted' => Time.parse('2020-07-10 00:00:00 UTC'),
        'description' => 'Summer Campus Fee'
      }
    ]
  end
  let(:transactions_collector) { double(get_feed: transactions_data) }
  before { allow(User::Finances::Transactions).to receive(:new).and_return(transactions_collector) }

  subject { described_class.new(user) }

  describe '#find_by_id' do
    let(:result) { subject.find_by_id(billing_item_id) }
    context 'when billing item is not present' do
      let(:billing_item_id) { '000000000000123' }
      it 'returns nil' do
        expect { result }.to raise_error(RuntimeError, 'Billling Item not found')
      end
    end
    context 'when billing item is not present' do
      let(:billing_item_id) { '000000000000097' }
      it 'returns billing item' do
        expect(result).to be_an_instance_of User::Finances::BillingItem
      end
    end
  end

  describe '#all' do
    let(:result) { subject.all }
    it 'returns billing items' do
      expect(result).to be_an_instance_of Array
      expect(result.count).to eq 1
      expect(result.first).to be_an_instance_of User::Finances::BillingItem
    end
  end

  describe '#billing_items' do
    let(:result) { subject.send(:billing_items) }
    it 'returns billing items hash' do
      expect(result).to be_an_instance_of Hash
      expect(result.keys).to eq ['000000000000097']
      expect(result['000000000000097']).to be_an_instance_of User::Finances::BillingItem
    end
  end
end
