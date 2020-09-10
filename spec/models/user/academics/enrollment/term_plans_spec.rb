describe User::Academics::Enrollment::TermPlans do
  let(:uid) { '61889' }
  let(:user) { User::Current.new(uid) }
  let(:current_and_future_term_plans) do
    [
      User::Academics::TermPlans::TermPlan.new({'term_id' => '2208', 'acad_career' => 'UGRD', 'acad_program' => 'UCLS', 'acad_plan' => '25000FPFU'}),
      User::Academics::TermPlans::TermPlan.new({'term_id' => '2212', 'acad_career' => 'UGRD', 'acad_program' => 'UCLS', 'acad_plan' => '25000U'}),
    ]
  end
  let(:term_plans_provider) { double(current_and_future: current_and_future_term_plans) }

  before do
    allow(User::Academics::TermPlans::TermPlans).to receive(:new).with(user).and_return(term_plans_provider)
  end

  subject { described_class.new(user) }

  describe '#current_and_future' do
    let(:result) { subject.current_and_future }
    it 'returns collection of enrollment term plans' do
      expect(result).to be_an_instance_of Array
      expect(result.count).to eq 2
      result.each do |enrollment_term_plan|
        expect(enrollment_term_plan).to be_an_instance_of User::Academics::Enrollment::TermPlan
      end
    end
  end
end
