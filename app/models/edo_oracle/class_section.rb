class EdoOracle::ClassSection
  def initialize(data)
    @data = data || {}
  end

  def section_id
    @data['section_id']
  end

  def cs_course_id
    @data['cs_course_id']
  end

  def offering_number
    @data['offering_number']
  end

  def section_number
    @data['section_num']
  end

  def term_id
    @data['term_id']
  end

  def session_id
    @data['session_id']
  end

  def primary
    @data['primary'] == 'true'
  end

  def instruction_format
    @data['instruction_format']
  end

  def primary_associated_section_id
    @data['primary_associated_section_id']
  end

  def section_display_name
    @data['section_display_name']
  end

  def topic_description
    @data['topic_description']
  end

  def print_in_schedule_of_classes
    @data['print_in_schedule_of_classes']
  end

  def enroll_limit
    @data['enroll_limit']
  end

  def as_json(options={})
    {
      section_id: section_id,
      cs_course_id: cs_course_id,
      offering_number: offering_number,
      section_num: section_number,
      term_id: term_id,
      session_id: session_id,
      primary: primary,
      instruction_format: instruction_format,
      primary_associated_section_id: primary_associated_section_id,
      section_display_name: section_display_name,
      topic_description: topic_description,
      print_in_schedule_of_classes: print_in_schedule_of_classes,
      enroll_limit: enroll_limit
    }
  end

end
