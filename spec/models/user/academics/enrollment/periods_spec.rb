describe User::Academics::Enrollment::Periods do
  let(:phase_1_ugrd_period) { {career: 'UGRD', :id => 'PRI1'} }
  let(:phase_1_5_ugrd_period) { {career: 'UGRD', :id => 'PH1.5'} }
  let(:phase_2_ugrd_period) { {career: 'UGRD', :id => 'PRI2'} }
  let(:adjust_ugrd_period) { {career: 'UGRD', :id => 'ADJ'} }
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

  describe '#as_json' do
    let(:json_array) { subject.as_json }
    it 'returns array for json' do
      expect(json_array).to be_an_instance_of Array
      expect(json_array.count).to eq 4
      expect(json_array[0][:id]).to eq 'PRI1'
      expect(json_array[1][:id]).to eq 'PH1.5'
      expect(json_array[2][:id]).to eq 'PRI2'
      expect(json_array[3][:id]).to eq 'ADJ'
    end
  end
end
