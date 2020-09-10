class User::Academics::Enrollment::Term
  attr_accessor :user

  attr_accessor :term_id
  attr_accessor :term_descr
  attr_accessor :acad_career

  alias_attribute :description, :term_descr
  alias_attribute :academic_career_code, :acad_career

  def initialize(attrs={})
    attrs.each do |key, value|
      method = "#{key.to_s.underscore}="
      self.send(method, value) if respond_to?(method)
    end
  end

  def as_json(options={})
    {
      academicCareerCode: academic_career_code,
      description: description,
      termId: term_id,
    }
  end
end
