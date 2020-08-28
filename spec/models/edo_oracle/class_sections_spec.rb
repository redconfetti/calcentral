describe EdoOracle::ClassSections do
  let(:cs_course_id) { '104373' }
  let(:offering_number) { 1 }
  let(:section_number) { '164' }
  let(:term_id) { '2208' }
  let(:session_id) { '1' }
  let(:class_section_rows) do
    [
      {
        'section_id' => '17584',
        'term_id' => '2208',
        'session_id' => '1',
        'cs_course_id' => '104373',
        'offering_number' => 1,
        'primary' => 'true',
        'section_num' => '164',
        'instruction_format' => 'LEC',
        'primary_associated_section_id' => '17584',
        'section_display_name' => 'COMPSCI 294',
        'topic_description' => nil,
        'print_in_schedule_of_classes' => 'Y',
        'enroll_limit' => 30
      }
    ]
  end
  subject { described_class.new(cs_course_id, offering_number, section_number, term_id, session_id) }
  before { allow(EdoOracle::Queries).to receive(:get_class_sections).and_return(class_section_rows) }
  describe '#all' do
    it 'returns all class section objects' do
      result = subject.all
      expect(result.count).to eq 1
      expect(result[0]).to be_an_instance_of EdoOracle::ClassSection
    end
  end
end
