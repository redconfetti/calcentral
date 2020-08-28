describe EdoOracle::ClassSection do
  let(:attributes) do
    {
      'section_id' => '17584',
      'cs_course_id' => '104373',
      'offering_number' => 1,
      'section_num' => '164',
      'term_id' => '2208',
      'session_id' => '1',
      'primary' => 'true',
      'instruction_format' => 'LEC',
      'primary_associated_section_id' => '17584',
      'section_display_name' => 'COMPSCI 294',
      'topic_description' => nil,
      'print_in_schedule_of_classes' => 'Y',
      'enroll_limit' => 30
    }
  end
  subject { described_class.new(attributes) }
  its(:section_id) { should eq '17584' }
  its(:cs_course_id) { should eq '104373' }
  its(:offering_number) { should eq 1 }
  its(:section_number) { should eq '164' }
  its(:term_id) { should eq '2208' }
  its(:session_id) { should eq '1' }
  its(:primary) { should eq true }
  its(:instruction_format) { should eq 'LEC' }
  its(:primary_associated_section_id) { should eq '17584' }
  its(:section_display_name) { should eq 'COMPSCI 294' }
  its(:topic_description) { should eq nil }
  its(:print_in_schedule_of_classes) { should eq 'Y' }
  its(:enroll_limit) { should eq 30 }

  describe '#to_json' do
    let(:result) { JSON.parse(subject.to_json) }
    it 'should include section_id' do
      expect(result['section_id']).to eq '17584'
    end
    it 'should include cs_course_id' do
      expect(result['cs_course_id']).to eq '104373'
    end
    it 'should include offering_number' do
      expect(result['offering_number']).to eq 1
    end
    it 'should include section_num' do
      expect(result['section_num']).to eq '164'
    end
    it 'should include term_id' do
      expect(result['term_id']).to eq '2208'
    end
    it 'should include session_id' do
      expect(result['session_id']).to eq '1'
    end
    it 'should include primary' do
      expect(result['primary']).to eq true
    end
    it 'should include instruction_format' do
      expect(result['instruction_format']).to eq 'LEC'
    end
    it 'should include primary_associated_section_id' do
      expect(result['primary_associated_section_id']).to eq '17584'
    end
    it 'should include section_display_name' do
      expect(result['section_display_name']).to eq 'COMPSCI 294'
    end
    it 'should include topic_description' do
      expect(result['topic_description']).to eq nil
    end
    it 'should include print_in_schedule_of_classes' do
      expect(result['print_in_schedule_of_classes']).to eq 'Y'
    end
    it 'should include enroll_limit' do
      expect(result['enroll_limit']).to eq 30
    end
  end

end
