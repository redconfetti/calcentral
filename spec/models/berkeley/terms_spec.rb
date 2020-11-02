describe Berkeley::Terms do
  let(:options) {{fake_now: fake_now}}
  before { allow(Settings.hub_term_proxy).to receive(:fake).and_return true }
  subject {Berkeley::Terms.fetch(options)}

  let(:term_data) do
    [
      {
        'career_code'=>'UGRD',
        'term_id'=>'2198',
        'term_type'=>'Fall',
        'term_year'=>'2019',
        'term_code'=>'D',
        'term_descr'=>'Fall 2019',
        'term_begin_date'=>'2019-08-21T00:00:00.000Z',
        'term_end_date'=>'2019-12-20T00:00:00.000Z',
        'class_begin_date'=>nil,
        'class_end_date'=>nil,
        'instruction_end_date'=>nil,
        'grades_entered_date'=>nil,
        'end_drop_add_date'=>'2019-09-18T00:00:00.000Z',
        'is_summer'=>'N'
      },
      {
        'career_code'=>'UGRD',
        'term_id'=>'2195',
        'term_type'=>'Summer',
        'term_year'=>'2019',
        'term_code'=>'C',
        'term_descr'=>'Summer 2019',
        'term_begin_date'=>'2019-05-28T00:00:00.000Z',
        'term_end_date'=>'2019-08-16T00:00:00.000Z',
        'class_begin_date'=>nil,
        'class_end_date'=>nil,
        'instruction_end_date'=>nil,
        'grades_entered_date'=>nil,
        'end_drop_add_date'=>nil,
        'is_summer'=>'Y'
      },
      {
        'career_code'=>'UGRD',
        'term_id'=>'2192',
        'term_type'=>'Spring',
        'term_year'=>'2019',
        'term_code'=>'B',
        'term_descr'=>'Spring 2019',
        'term_begin_date'=>'2019-01-15T00:00:00.000Z',
        'term_end_date'=>'2019-05-17T00:00:00.000Z',
        'class_begin_date'=>'2019-01-22T00:00:00.000Z',
        'class_end_date'=>'2019-05-03T00:00:00.000Z',
        'instruction_end_date'=>'2019-05-10T00:00:00.000Z',
        'grades_entered_date'=>nil,
        'end_drop_add_date'=>'2019-02-13T00:00:00.000Z',
        'is_summer'=>'N'
      },
      {
        'career_code'=>'UGRD',
        'term_id'=>'2188',
        'term_type'=>'Fall',
        'term_year'=>'2018',
        'term_code'=>'D',
        'term_descr'=>'Fall 2018',
        'term_begin_date'=>'2018-08-15T00:00:00.000Z',
        'term_end_date'=>'2018-12-14T00:00:00.000Z',
        'class_begin_date'=>'2018-08-22T00:00:00.000Z',
        'class_end_date'=>'2018-11-30T00:00:00.000Z',
        'instruction_end_date'=>'2018-12-07T00:00:00.000Z',
        'grades_entered_date'=>'2018-12-24T00:00:00.000Z',
        'end_drop_add_date'=>'2018-09-12T00:00:00.000Z',
        'is_summer'=>'N'
      },
      {
        'career_code'=>'UGRD',
        'term_id'=>'2185',
        'term_type'=>'Summer',
        'term_year'=>'2018',
        'term_code'=>'C',
        'term_descr'=>'Summer 2018',
        'term_begin_date'=>'2018-05-21T00:00:00.000Z',
        'term_end_date'=>'2018-08-10T00:00:00.000Z',
        'class_begin_date'=>nil,
        'class_end_date'=>nil,
        'instruction_end_date'=>nil,
        'grades_entered_date'=>nil,
        'end_drop_add_date'=>nil,
        'is_summer'=>'Y'
      },
      {
        'career_code'=>'UGRD',
        'term_id'=>'2182',
        'term_type'=>'Spring',
        'term_year'=>'2018',
        'term_code'=>'B',
        'term_descr'=>'Spring 2018',
        'term_begin_date'=>'2018-01-09T00:00:00.000Z',
        'term_end_date'=>'2018-05-11T00:00:00.000Z',
        'class_begin_date'=>'2018-01-16T00:00:00.000Z',
        'class_end_date'=>'2018-04-27T00:00:00.000Z',
        'instruction_end_date'=>'2018-05-04T00:00:00.000Z',
        'grades_entered_date'=>'2018-06-30T00:00:00.000Z',
        'end_drop_add_date'=>'2018-02-16T00:00:00.000Z',
        'is_summer'=>'N'
      },
      {
        'career_code'=>'UGRD',
        'term_id'=>'2178',
        'term_type'=>'Fall',
        'term_year'=>'2017',
        'term_code'=>'D',
        'term_descr'=>'Fall 2017',
        'term_begin_date'=>'2017-08-16T00:00:00.000Z',
        'term_end_date'=>'2017-12-15T00:00:00.000Z',
        'class_begin_date'=>'2017-08-23T00:00:00.000Z',
        'class_end_date'=>'2017-12-01T00:00:00.000Z',
        'instruction_end_date'=>'2017-12-08T00:00:00.000Z',
        'grades_entered_date'=>'2017-12-20T00:00:00.000Z',
        'end_drop_add_date'=>'2017-09-22T00:00:00.000Z',
        'is_summer'=>'N'
      },
      {
        'career_code'=>'UGRD',
        'term_id'=>'2175',
        'term_type'=>'Summer',
        'term_year'=>'2017',
        'term_code'=>'C',
        'term_descr'=>'Summer 2017',
        'term_begin_date'=>'2017-05-22T00:00:00.000Z',
        'term_end_date'=>'2017-08-11T00:00:00.000Z',
        'class_begin_date'=>nil,
        'class_end_date'=>nil,
        'instruction_end_date'=>nil,
        'grades_entered_date'=>nil,
        'end_drop_add_date'=>nil,
        'is_summer'=>'Y'
      },
      {
        'career_code'=>'UGRD',
        'term_id'=>'2172',
        'term_type'=>'Spring',
        'term_year'=>'2017',
        'term_code'=>'B',
        'term_descr'=>'Spring 2017',
        'term_begin_date'=>'2017-01-10T00:00:00.000Z',
        'term_end_date'=>'2017-05-12T00:00:00.000Z',
        'class_begin_date'=>nil,
        'class_end_date'=>nil,
        'instruction_end_date'=>nil,
        'grades_entered_date'=>nil,
        'end_drop_add_date'=>nil,
        'is_summer'=>'N'
      }
    ]
  end

  shared_examples 'a list of campus terms' do
    its(:campus) {should be_is_a Hash}
    it 'is in reverse chronological order' do
      previous_term = nil
      subject.campus.each do |slug, term|
        expect(term).to be_is_a Berkeley::Term
        expect(slug).to eq term.slug
        expect(term.campus_solutions_id).to be_present
        if previous_term
          expect(term.start).to be < previous_term.start
          expect(term.end).to be < previous_term.end
        end
        previous_term = term
      end
    end
  end

  context 'working against test data', if: CampusOracle::Queries.test_data? do
    let(:fake_now) { Settings.terms.fake_now.to_datetime }
    it 'finds the legacy SIS CT term' do
      expect(subject.sis_current_term.slug).to eq 'fall-2013'
    end
    context 'in Fall 2013' do
      let(:fake_now) {DateTime.parse('2013-10-10')}
      it_behaves_like 'a list of campus terms'
      its('current.slug') {should eq 'fall-2013'}
      its('running.slug') {should eq 'fall-2013'}
      its('next.slug') {should eq 'spring-2014'}
      its('future.slug') {should eq 'summer-2014'}
      its('grading_in_progress') {should be_nil}
    end
    context 'in Spring 2016' do
      let(:fake_now) {DateTime.parse('2016-03-10')}
      it_behaves_like 'a list of campus terms'
      its('current.slug') {should eq 'spring-2016'}
      its('running.slug') {should eq 'spring-2016'}
      its('next.slug') {should eq 'summer-2016'}
      its('future.slug') {should eq 'fall-2016'}
      its('grading_in_progress') {should be_nil}
    end
    context 'during final exams' do
      let(:fake_now) {DateTime.parse('2013-12-14')}
      it_behaves_like 'a list of campus terms'
      its('current.slug') {should eq 'fall-2013'}
      its('running.slug') {should eq 'fall-2013'}
      its('next.slug') {should eq 'spring-2014'}
      its('future.slug') {should eq 'summer-2014'}
      its('grading_in_progress') {should be_nil}
    end
    context 'between terms' do
      let(:fake_now) {DateTime.parse('2013-12-31')}
      it_behaves_like 'a list of campus terms'
      its('current.slug') {should eq 'spring-2014'}
      its(:running) {should be_nil}
      its('next.slug') {should eq 'summer-2014'}
      its('future.slug') {should eq 'fall-2014'}
      its('grading_in_progress.slug') {should eq 'fall-2013'}
    end
    context 'in last of available terms' do
      let(:fake_now) {DateTime.parse('2017-1-27')}
      it_behaves_like 'a list of campus terms'
      its('current.slug') {should eq 'spring-2017'}
      its('running.slug') {should eq 'spring-2017'}
      its(:next) {should be_nil}
      its(:future) {should be_nil}
      its('grading_in_progress') {should be_nil}
    end
    context 'limiting semester range' do
      let(:options) {{oldest: 'summer-2012'}}
      it_behaves_like 'a list of campus terms'
      it 'does not include older semesters' do
        expect(subject.campus.keys.last).to eq 'summer-2012'
      end
    end
  end

  context 'legacy source-of-record checks' do
    let(:fake_now) {Settings.terms.fake_now.to_datetime}
    before { allow(Settings.terms).to receive(:legacy_cutoff).and_return legacy_cutoff }
    let(:term_slug) {'spring-2014'}
    context 'term is before legacy cutoff' do
      let(:legacy_cutoff) { 'summer-2014' }
      it 'reports legacy status' do
        expect(subject.campus[term_slug].legacy?).to eq true
        expect(Berkeley::Terms.legacy?('2014', 'B')).to eq true
      end
    end
    context 'term is equal to legacy cutoff' do
      let(:legacy_cutoff) { 'spring-2014' }
      it 'reports legacy status' do
        expect(subject.campus[term_slug].legacy?).to eq true
        expect(Berkeley::Terms.legacy?('2014', 'B')).to eq true
      end
    end
    context 'term is after legacy cutoff' do
      let(:fake_now) {DateTime.parse('2016-07-27')}
      let(:legacy_cutoff) { 'fall-2015' }
      let(:term_slug) {'spring-2016'}
      it 'reports Campus Solutions status' do
        expect(subject.campus[term_slug].legacy?).to eq false
        expect(Berkeley::Terms.legacy?('2016', 'B')).to eq false
      end
    end
    context 'term not found' do
      let(:legacy_cutoff) { 'fall-2013' }
      it 'returns false from class methods' do
        expect(subject.campus['spring-2017']).to be_nil
        expect(Berkeley::Terms.legacy?('1969', 'B')).to eq false
      end
    end
  end

  describe '.legacy_group' do
    before { allow(Settings.features).to receive(:hub_term_api).and_return true }
    let(:terms) { Berkeley::Terms.fetch(fake_now: DateTime.parse('2016-07-12')).campus.values[0..2] }
    it 'returns terms grouped by data source' do
      result = Berkeley::Terms.legacy_group(terms)
      expect(result[:legacy].count).to eq 1
      expect(result[:legacy][0]).to eq terms[2]
      expect(result[:sisedo].count).to eq 2
      expect(result[:sisedo][0]).to eq terms[0]
    end
  end

  describe '.find_by_campus_solutions_id' do
    it 'returns term object for given campus solutions id' do
      spring_2010_term = described_class.find_by_campus_solutions_id('2102')
      expect(spring_2010_term.campus_solutions_id).to eq '2102'
      expect(spring_2010_term.name).to eq 'Spring'
      expect(spring_2010_term.year).to eq 2010
    end
  end

  describe '.campus_solutions_id_to_name' do
    it 'converts term id for fall 2099 to name' do
      expect(described_class.campus_solutions_id_to_name('2998')).to eq 'Fall 2099'
    end
    it 'converts term id for spring 1900 to name' do
      expect(described_class.campus_solutions_id_to_name('1002')).to eq 'Spring 1900'
    end
    it 'converts term id for summer 2020 to name' do
      expect(described_class.campus_solutions_id_to_name('2205')).to eq 'Summer 2020'
    end
    it 'raises error if term id begins with invalid century number' do
      expect { described_class.campus_solutions_id_to_name('3001') }.to raise_error(ArgumentError, 'Invalid century number for \'3001\'. Must begin with \'1\' or \'2\'')
    end
    it 'raises error if term id ends with invalid term number' do
      expect { described_class.campus_solutions_id_to_name('2204') }.to raise_error(ArgumentError, 'Invalid term number for \'2204\'. Must end with \'2\', \'5\', or \'8\'')
    end
  end

  describe '#fetch_terms_from_api' do
    context 'Hub Term API enabled' do
      before { allow(Settings.features).to receive(:hub_term_api).and_return true }
      subject { Berkeley::Terms.new(fake_now: DateTime.parse('2016-07-12')) }
      it 'finds all post-legacy data' do
        terms = subject.fetch_terms_from_api
        expect(terms.length).to eq 2
        expect(terms[0].to_english).to eq 'Spring 2017'
        expect(terms[1].to_english).to eq 'Fall 2016'
      end
      context 'honors the legacy SIS cutoff' do
        before { allow(Settings.terms).to receive(:legacy_cutoff).and_return 'spring-2016' }
        it 'finds all post-legacy data' do
          terms = subject.fetch_terms_from_api
          expect(terms.length).to eq 3
          expect(terms[0].to_english).to eq 'Spring 2017'
          expect(terms[1].to_english).to eq 'Fall 2016'
          expect(terms[2].to_english).to eq 'Summer 2016'
          expect(subject.sis_current_term.to_english).to eq 'Summer 2016'
        end
      end
    end

    context 'Hub Term API disabled and load file disabled' do
      before do
        allow(Settings.features).to receive(:hub_term_api).and_return false
        allow(Settings.features).to receive(:use_term_definitions_json_file).and_return false
        allow(EdoOracle::Queries).to receive(:get_undergrad_terms).and_return term_data
      end
      subject { Berkeley::Terms.new(fake_now: DateTime.parse('2018-07-12')) }
      it 'loads terms from edodb with only 2 future terms and sorted in proper order' do
        terms = subject.load_terms_from_edo_db
        expect(terms.length).to eq 7
        expect(terms[0].to_english).to eq 'Spring 2019'
        expect(terms[1].to_english).to eq 'Fall 2018'
        expect(terms[2].to_english).to eq 'Summer 2018'
        expect(terms[3].to_english).to eq 'Spring 2018'
        expect(terms[4].to_english).to eq 'Fall 2017'
        expect(terms[5].to_english).to eq 'Summer 2017'
        expect(terms[6].to_english).to eq 'Spring 2017'
      end
    end
  end

  describe 'short cache lifespan when API has errors' do
    before { allow(Settings.features).to receive(:hub_term_api).and_return true }
    include_context 'short-lived cache write of Hash on failures'
    include_context 'expecting logs from server errors'
    let(:fake_now) {DateTime.parse('2016-06-10')}
    let(:uri) { URI.parse(Settings.hub_term_proxy.base_url) }
    let(:status) { 502 }
    before do
      allow(Settings.hub_term_proxy).to receive(:fake).and_return false
      stub_request(:any, /.*#{uri}.*/).to_return(status: status)
    end
    it 'reports an error' do
      expect(subject[:statusCode]).to eq 503
    end
  end

end
