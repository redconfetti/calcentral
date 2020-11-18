describe User::Academics::Enrollment::Presentations do
  let(:uid) { '61889' }
  let(:user) { User::Current.new(uid) }
  let(:term_plan_default_fall_2020) { build(:user_academics_enrollment_term_plan) }
  let(:term_plan_law_fall_2020) { build(:user_academics_enrollment_term_plan, {term_plan: build(:user_academics_term_plans_term_plan, :law)}) }
  let(:term_plan_grad_fall_2020_1) do
    build(:user_academics_enrollment_term_plan, {
      term_plan: build(:user_academics_term_plans_term_plan, :fall_2020, :grad_gacad)
    })
  end
  let(:term_plan_grad_fall_2020_2) do
    build(:user_academics_enrollment_term_plan, {
      term_plan: build(:user_academics_term_plans_term_plan, :fall_2020, :grad_uced)
    })
  end
  let(:term_plan_haas_execmba_fall_2020) do
    build(:user_academics_enrollment_term_plan, {
      term_plan: build(:user_academics_term_plans_term_plan, :fall_2020, :grad_haas_execmba)
    })
  end
  let(:term_plan_grad_spring_2021) do
    build(:user_academics_enrollment_term_plan, {
      term_plan: build(:user_academics_term_plans_term_plan, :spring_2021, :grad_gacad)
    })
  end
  let(:term_plan_law_spring_2021) do
    build(:user_academics_enrollment_term_plan, {
      term_plan: build(:user_academics_term_plans_term_plan, :spring_2021, :law_lprfl)
    })
  end
  let(:term_plans) { [term_plan_default_fall_2020] }

  let(:enrollment_term_ugrd_fall_2020) { build(:user_academics_enrollment_term, :ugrd, :fall_2020) }
  let(:enrollment_term_grad_fall_2020) { build(:user_academics_enrollment_term, :grad, :fall_2020) }
  let(:enrollment_term_ugrd_spring_2021) { build(:user_academics_enrollment_term, :ugrd, :spring_2021) }
  let(:enrollment_term_law_spring_2021) { build(:user_academics_enrollment_term, :law, :spring_2021) }
  let(:enrollment_terms) { [enrollment_term_ugrd_fall_2020, enrollment_term_ugrd_spring_2021] }

  before do
    allow(subject).to receive(:term_plans).and_return(term_plans)
    allow(subject).to receive(:active_career_terms).and_return(enrollment_terms)
  end

  subject { described_class.new(user) }

  describe '#all' do
    let(:result) { subject.all }
    context 'when multiple designs present for each term' do
      let(:enrollment_terms) { [enrollment_term_grad_fall_2020, enrollment_term_law_spring_2021] }
      let(:term_plans) do
        [
          term_plan_grad_fall_2020_1,
          term_plan_grad_fall_2020_2,
          term_plan_haas_execmba_fall_2020,
          term_plan_grad_spring_2021,
          term_plan_law_spring_2021,
        ]
      end
      it 'returns collection of presentations that are unique by design and term' do
        expect(result).to be_an_instance_of Array
        expect(result.count).to eq 3
        expect(result[0]).to be_an_instance_of User::Academics::Enrollment::Presentation
        expect(result[1]).to be_an_instance_of User::Academics::Enrollment::Presentation
        expect(result[2]).to be_an_instance_of User::Academics::Enrollment::Presentation

        default_2208 = result.find {|presentation| presentation.design == 'default' && presentation.term_id == '2208'}
        expect(default_2208).to be
        expect(default_2208.term_plans.count).to eq 2

        haasExecMba_2208 = result.find {|presentation| presentation.design == 'haasExecMba' && presentation.term_id == '2208'}
        expect(haasExecMba_2208).to be
        expect(haasExecMba_2208.term_plans.count).to eq 1

        law_2212 = result.find {|presentation| presentation.design == 'law' && presentation.term_id == '2212'}
        expect(law_2212).to be
        expect(law_2212.term_plans.count).to eq 1

        default_2212 = result.find {|presentation| presentation.design == 'default' && presentation.term_id == '2212'}
        expect(default_2212).to_not be
      end
    end
  end

  describe '#design_terms' do
    let(:applicable_term_plans) do
      [
        term_plan_grad_fall_2020_1,
        term_plan_grad_fall_2020_2,
        term_plan_grad_spring_2021,
        term_plan_law_spring_2021,
      ]
    end
    before { allow(subject).to receive(:applicable_term_plans).and_return(applicable_term_plans) }
    let(:result) { subject.send(:design_terms) }

    it 'returns unique term id and design pairs' do
      expect(result).to eq [['default','2208'],['default','2212'],['law','2212']]
    end
  end

  describe '#applicable_term_plans' do
    let(:result) { subject.send(:applicable_term_plans) }
    context 'when term plans intersect with active enrollment terms' do
      let(:term_plans) { [term_plan_default_fall_2020] }
      let(:enrollment_terms) { [enrollment_term_ugrd_fall_2020, enrollment_term_ugrd_spring_2021] }
      it 'returns applicable/active term plans' do
        expect(result).to be_an_instance_of Array
        expect(result.count).to eq 1
        expect(result.first).to be_an_instance_of User::Academics::Enrollment::TermPlan
        expect(result.first.term_id).to eq '2208'
        expect(result.first.academic_career_code).to eq 'UGRD'
      end
    end
    context 'when term plans do not intersect with active enrollment terms' do
      let(:term_plans) { [term_plan_grad_spring_2021] }
      let(:enrollment_terms) { [enrollment_term_ugrd_fall_2020, enrollment_term_ugrd_spring_2021] }
      it 'returns empty array' do
        expect(result).to be_an_instance_of Array
        expect(result.count).to eq 0
      end
    end
  end

end
