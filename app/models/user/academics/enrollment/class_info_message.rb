class User::Academics::Enrollment::ClassInfoMessage
  attr_reader :term_id, :academic_career_code

  def initialize(term_id:, academic_career_code:)
    @academic_career_code = academic_career_code
    @term_id = term_id
  end

  def message
    return unless has_key?
    @message ||= CampusSolutions::MessageCatalog.get_message(key)
  end

  def text
    message[:messageText]
  end

  def description
    message[:descrlong]
  end

  def as_json(options={})
    {
      text: text,
      description: description,
    }
  end

  private

  def term
    ::Terms.find_undergraduate(term_id)
  end

  def semester_name
    term.type.downcase
  end

  def key
    "class_info_message_#{academic_career_code.downcase}_#{semester_name}"
  end

  def has_key?
    CampusSolutions::MessageCatalog::CATALOG.fetch(key) { false }
  end
end
