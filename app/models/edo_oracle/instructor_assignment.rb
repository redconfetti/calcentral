class EdoOracle::InstructorAssignment
  def initialize(data)
    @data = data || {}
  end

  def term_id
    @data['term_id']
  end

  def session_id
    @data['session_id']
  end

  def cs_course_id
    @data['cs_course_id']
  end

  def offering_number
    @data['offering_number']
  end

  def section_number
    @data['section_number']
  end

  def ldap_uid
    @data['ldap_uid']
  end

  def person_name
    @data['person_name']
  end

  def first_name
    @data['first_name']
  end

  def last_name
    @data['last_name']
  end

  def role_code
    @data['role_code']
  end

  def role_description
    @data['role_description']
  end

  def grade_roster_access
    @data['grade_roster_access']
  end

  def print_in_schedule
    @data['print_in_schedule']
  end

  def as_json(options={})
    {
      term_id: term_id,
      session_id: session_id,
      cs_course_id: cs_course_id,
      offering_number: offering_number,
      section_number: section_number,
      ldap_uid: ldap_uid,
      person_name: person_name,
      first_name: first_name,
      last_name: last_name,
      role_code: role_code,
      role_description: role_description,
      grade_roster_access: grade_roster_access,
      print_in_schedule: print_in_schedule,
    }
  end
end
