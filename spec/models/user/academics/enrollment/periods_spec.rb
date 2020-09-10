describe User::Academics::Enrollment::Periods do
  let(:phase_1_ugrd_period) do
    {
      :id => 'R7P1',
      career: 'UGRD',
      name: 'Phase 1 Begins',
      date: { epoch: 1587492000 },
      enddatetime: '2020-06-12T23:59:00'
    }
  end
  let(:phase_1_5_ugrd_period) do
    {
      :id => 'PH1.5',
      name: 'Phase 1.5 Begins',
      career: 'UGRD',
      date: { epoch: 1594234800 },
      enddatetime: '2020-07-11T23:59:00'
    }
  end
  let(:phase_2_ugrd_period) do
    {
      :id => 'PRI2',
      name: 'Phase 2 Begins',
      career: 'UGRD',
      date: { epoch: 1595527200 },
      enddatetime: '2020-08-16T23:59:00'
    }
  end
  let(:adjust_ugrd_period) do
    {
      :id => 'ADJ',
      name: 'Adjustment Begins',
      career: 'UGRD',
      date: { epoch: 1597680000 },
      enddatetime: '2020-10-30T23:59:00'
    }
  end

  let(:periods_data) do
    [
      phase_1_ugrd_period,
      phase_1_5_ugrd_period,
      phase_2_ugrd_period,
      adjust_ugrd_period,
    ]
  end
  subject { described_class.new(periods_data) }

  describe '#all' do
    let(:all_periods) { subject.all }
    it 'returns all enrollment period objects' do
      expect(all_periods).to be_an_instance_of Array
      expect(all_periods.count).to eq 4
      all_periods.each do |period|
        expect(period).to be_an_instance_of ::User::Academics::Enrollment::Period
      end
    end
  end

  describe '#for_career' do
    let(:phase_1_grad_period) { { id: 'PRI1', acadCareer: 'GRAD'} }
    let(:periods_data) { [phase_1_ugrd_period, phase_1_grad_period] }
    let(:career_periods) { subject.for_career('GRAD') }
    it 'returns only careers matching career code' do
      expect(career_periods.count).to eq 1
      expect(career_periods[0].career).to eq 'GRAD'
      expect(career_periods[0].id).to eq 'PRI1'
    end
  end

  describe '#to_json' do
    let(:json_string) { subject.to_json }
    let(:json_array) { JSON.parse(json_string) }
    it 'returns array for json' do
      expect(json_array).to be_an_instance_of Array
      expect(json_array.count).to eq 4
      expect(json_array[0]['id']).to eq 'R7P1'
      expect(json_array[1]['id']).to eq 'PH1.5'
      expect(json_array[2]['id']).to eq 'PRI2'
      expect(json_array[3]['id']).to eq 'ADJ'
    end
  end
end
