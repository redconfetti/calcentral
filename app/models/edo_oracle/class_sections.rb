class EdoOracle::ClassSections

  def initialize(cs_course_id, offering_number, section_number, term_id, session_id)
    @cs_course_id = cs_course_id
    @offering_number = offering_number
    @section_number = section_number
    @term_id = term_id
    @session_id = session_id
  end

  def all
    @all ||= data.collect do |class_section_data|
      ::EdoOracle::ClassSection.new(class_section_data)
    end
  end

  private

  def data
    @data ||= EdoOracle::Queries.get_class_sections(@cs_course_id, @offering_number, @section_number, @term_id, @session_id)
  end
end
