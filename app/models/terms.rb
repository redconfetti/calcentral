class Terms

  # Legacy SIS term code, only used for integration with legacy DB sources
  LEGACY_CODES = {
    'B' => 'Spring',
    'C' => 'Summer',
    'D' => 'Fall',
  }

  SUMMER_SESSIONS = {
    '6W1' => 'A',
    '10W' => 'B',
    '8W' => 'C',
    '6W2' => 'D',
    '3W' => 'E'
  }

  def self.all
    data.collect {|t| Term.new(t) }
  end

  def self.find_undergraduate(term_id)
    undergraduate.find {|t| t.id == term_id }
  end

  def self.undergraduate
    all.select {|t| t.academic_career_code == ::Careers::UNDERGRADUATE }
  end

  def self.data
    Cached::Terms.new.get
  end
end
