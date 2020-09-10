class Terms
  def self.all
    @all ||= data.collect {|t| Term.new(t) }
  end

  def self.find_undergraduate(term_id)
    undergraduate.find {|t| t.id == term_id }
  end

  def self.undergraduate
    all.select {|t| t.career_code == 'UGRD' }
  end

  def self.data
    Cached::Terms.new.get
  end
end
