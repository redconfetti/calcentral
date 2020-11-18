describe User::Finances::BillingItem do
  let(:uid) { '61889' }
  let(:user) { User::Current.new(uid) }
  let(:now) { DateTime.parse('2020-08-28T09:27:42-07:00') }
  let(:billing_item_id) { '000000000000123' }
  let(:billing_item_sequence_data) do
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
  end
  subject { described_class.new(billing_item_id, user) }

  before do
    subject << billing_item_sequence_data
    allow(Settings.terms).to receive(:fake_now).and_return(now)
  end

  its(:amount) { should eq 0 }
  its(:amount_due) { should eq 0 }
  its(:description) { should eq 'Summer Campus Fee' }
  its(:transaction_number) { should eq nil }
  its(:term_id) { should eq '2205' }
  its(:due_date) { should eq DateTime.parse('2020-07-10 00:00:00 UTC') }
  its(:posted_on) { should eq DateTime.parse('2020-07-10 00:00:00 UTC') }
  its(:updated_on) { should eq DateTime.parse('2020-07-10 00:00:00 UTC') }
  its(:type) { should eq 'Charge' }
  its(:status) { should eq 'Paid' }
  its(:days_past_due) { should eq 49 }
  its(:term_name) { should eq ' ' }
end
