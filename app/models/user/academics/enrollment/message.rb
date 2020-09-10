class User::Academics::Enrollment::Message
  attr_reader :career_code, :semester_name

  def initialize(career_code:, semester_name:)
    @career_code = career_code
    @semester_name = semester_name.downcase
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

  def key
    "enrollment_message_#{career_code}_#{semester_name}"
  end

  def has_key?
    CampusSolutions::MessageCatalog::CATALOG.fetch(key) { false }
  end
end
