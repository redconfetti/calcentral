class User::Academics::Enrollment::EnrollmentClass
  attr_accessor :type
  attr_accessor :id
  attr_accessor :acadCareer
  attr_accessor :acadCareerDescr
  attr_accessor :subjectCatalog
  attr_accessor :title
  attr_accessor :ssrComponent
  attr_accessor :ssrComponentDescr
  attr_accessor :when
  attr_accessor :units
  attr_accessor :edd

  alias :career_code :acadCareer
  alias :career_description :acadCareerDescr
  alias :subject_catalog :subjectCatalog
  alias :ssr_component_code :ssrComponent
  alias :ssr_component_description :ssrComponentDescr

  def initialize(attrs = {})
    attrs.each do |key, value|
      send("#{key}=", value) if respond_to?("#{key}=")
    end
  end

  def has_early_drop_deadline?
    edd == 'Y'
  end

  def as_json(options={})
    {
      type: type,
      id: id,
      careerCode: acadCareer,
      careerDescription: acadCareerDescr,
      subjectCatalog: subjectCatalog,
      title: title,
      ssrComponentCode: ssrComponent,
      ssrComponentDescription: ssrComponentDescr,
      when: self.when,
      units: units,
      hasEarlyDropDeadline?: has_early_drop_deadline?,
    }
  end
end
