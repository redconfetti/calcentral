describe Berkeley::Term do

  context 'CS SIS' do
    subject { Berkeley::Term.new.from_edo_db(db_row) }
    let(:db_row) do
      {
        'career_code' => 'UGRD',
        'term_id' => '2255',
        'term_type' => 'Summer',
        'term_year' => '2025',
        'term_code' => 'C',
        'term_descr' => 'Summer 2025',
        'term_begin_date' => Time.parse('2025-05-19 00:00:00 UTC'),
        'term_end_date' => Time.parse('2025-08-01 23:59:59 UTC'),
        'class_begin_date' => Time.parse('2025-05-23 00:00:00 UTC'),
        'class_end_date' => Time.parse('2025-08-12 23:59:59 UTC'),
        'instruction_end_date' => Time.parse('2025-08-12 23:59:59 UTC'),
        'grades_entered_date' => Time.parse('2025-09-09 23:59:59 UTC'),
        'end_drop_add_date' => nil,
        'is_summer' => 'Y'
      }
    end

    describe '#from_edo_db' do
      it 'parses the feed' do
        expect(subject.slug).to eq 'summer-2025'
        expect(subject.year).to eq 2025
        expect(subject.code).to eq 'C'
        expect(subject.name).to eq 'Summer'
        expect(subject.campus_solutions_id).to eq '2255'
        expect(subject.is_summer).to eq true
        expect(subject.classes_start).to eq Time.zone.parse('2025-05-19 00:00:00').to_datetime
        expect(subject.classes_end).to eq Time.zone.parse('2025-08-01 00:00:00').to_datetime
        expect(subject.instruction_end).to eq Time.zone.parse('2025-08-01 00:00:00').to_datetime
        expect(subject.grades_entered).to eq Time.zone.parse('2025-08-29 00:00:00').to_datetime
        expect(subject.start).to eq Time.zone.parse('2025-05-19 00:00:00').to_datetime
        expect(subject.end).to eq Time.zone.parse('2025-08-01 00:00:00').to_datetime
        expect(subject.to_english).to eq 'Summer 2025'
        expect(subject.legacy?).to eq false
        expect(subject.end_drop_add).to be_blank
      end
    end

    describe 'to_h' do
      it 'returns hash representation of term' do
        expect(subject.to_h[:campus_solutions_id]).to eq '2255'
        expect(subject.to_h[:name]).to eq 'Summer'
        expect(subject.to_h[:year]).to eq 2025
        expect(subject.to_h[:code]).to eq 'C'
        expect(subject.to_h[:slug]).to eq 'summer-2025'
        expect(subject.to_h[:to_english]).to eq 'Summer 2025'
        expect(subject.to_h[:start]).to eq Time.zone.parse('2025-05-19 00:00:00').to_datetime
        expect(subject.to_h[:end]).to eq Time.zone.parse('2025-08-01 00:00:00').to_datetime
        expect(subject.to_h[:classes_start]).to eq Time.zone.parse('2025-05-19 00:00:00').to_datetime
        expect(subject.to_h[:classes_end]).to eq Time.zone.parse('2025-08-01 00:00:00').to_datetime
        expect(subject.to_h[:instruction_end]).to eq Time.zone.parse('2025-08-01 00:00:00').to_datetime
        expect(subject.to_h[:grades_entered]).to eq Time.zone.parse('2025-08-29 00:00:00').to_datetime
        expect(subject.to_h[:is_summer]).to eq true
        expect(subject.to_h[:legacy?]).to eq false
        expect(subject.to_h[:end_drop_add]).to eq false
      end
    end

    describe 'to_s' do
      it 'returns string representation of term' do
        expect(subject.to_s).to eq '#<Berkeley::Term> {:campus_solutions_id=>"2255", :name=>"Summer", :year=>2025, :code=>"C", :slug=>"summer-2025", :to_english=>"Summer 2025", :start=>Mon, 19 May 2025 00:00:00 -0700, :end=>Fri, 01 Aug 2025 00:00:00 -0700, :classes_start=>Mon, 19 May 2025 00:00:00 -0700, :classes_end=>Fri, 01 Aug 2025 00:00:00 -0700, :instruction_end=>Fri, 01 Aug 2025 00:00:00 -0700, :grades_entered=>Fri, 29 Aug 2025 00:00:00 -0700, :is_summer=>true, :legacy?=>false, :end_drop_add=>false}'
      end
    end
  end

  context 'legacy SIS' do
    subject {Berkeley::Term.new(db_row)}
    context 'Summer Sessions' do
      let(:db_row) {{
        'term_yr' => '2014',
        'term_cd' => 'C',
        'term_status' => 'CS',
        'term_status_desc' => 'Current Summer',
        'term_name' => 'Summer',
        'term_start_date' => Time.gm(2014, 5, 27),
        'term_end_date' => Time.gm(2014, 8, 15)
      }}
      its(:slug) {should eq 'summer-2014'}
      its(:year) {should eq 2014}
      its(:code) {should eq 'C'}
      its(:name) {should eq 'Summer'}
      its(:campus_solutions_id) {should eq '2145'}
      its(:is_summer) {should eq true}
      its(:legacy_sis_term_status) {should eq 'CS'}
      its(:classes_start) {should eq Time.zone.parse('2014-05-27 00:00:00').to_datetime}
      its(:classes_end) {should eq Time.zone.parse('2014-08-15 23:59:59').to_datetime}
      its(:instruction_end) {should eq Time.zone.parse('2014-08-15 23:59:59').to_datetime}
      its(:start) {should eq Time.zone.parse('2014-05-27 00:00:00').to_datetime}
      its(:end) {should eq Time.zone.parse('2014-08-15 23:59:59').to_datetime}
      its(:to_english) {should eq 'Summer 2014'}
    end
    context 'Fall' do
      let(:db_row) {{
        'term_yr' => '2014',
        'term_cd' => 'D',
        'term_status' => 'FT',
        'term_status_desc' => 'Future Term',
        'term_name' => 'Fall',
        'term_start_date' => Time.gm(2014, 8, 28),
        'term_end_date' => Time.gm(2014, 12, 12)
      }}
      its(:slug) {should eq 'fall-2014'}
      its(:year) {should eq 2014}
      its(:code) {should eq 'D'}
      its(:name) {should eq 'Fall'}
      its(:campus_solutions_id) {should eq '2148'}
      its(:is_summer) {should eq false}
      its(:legacy_sis_term_status) {should eq 'FT'}
      its(:classes_start) {should eq Time.zone.parse('2014-08-28 00:00:00').to_datetime}
      its(:classes_end) {should eq Time.zone.parse('2014-12-05 23:59:59').to_datetime}
      its(:instruction_end) {should eq Time.zone.parse('2014-12-12 23:59:59').to_datetime}
      its(:start) {should eq Time.zone.parse('2014-08-21 00:00:00').to_datetime}
      its(:end) {should eq Time.zone.parse('2014-12-19 23:59:59').to_datetime}
      its(:to_english) {should eq 'Fall 2014'}
    end
    context 'Spring' do
      let(:db_row) {{
        'term_yr' => '2014',
        'term_cd' => 'B',
        'term_status' => 'CT',
        'term_status_desc' => 'Current Term',
        'term_name' => 'Spring',
        'term_start_date' => Time.gm(2014, 1, 21),
        'term_end_date' => Time.gm(2014, 5, 9)
      }}
      its(:slug) {should eq 'spring-2014'}
      its(:year) {should eq 2014}
      its(:code) {should eq 'B'}
      its(:name) {should eq 'Spring'}
      its(:campus_solutions_id) {should eq '2142'}
      its(:is_summer) {should eq false}
      its(:legacy_sis_term_status) {should eq 'CT'}
      its(:classes_start) {should eq Time.zone.parse('2014-01-21 00:00:00').to_datetime}
      its(:classes_end) {should eq Time.zone.parse('2014-05-02 23:59:59').to_datetime}
      its(:instruction_end) {should eq Time.zone.parse('2014-05-09 23:59:59').to_datetime}
      its(:start) {should eq Time.zone.parse('2014-01-14 00:00:00').to_datetime}
      its(:end) {should eq Time.zone.parse('2014-05-16 23:59:59').to_datetime}
      its(:to_english) {should eq 'Spring 2014'}
    end
  end
end
