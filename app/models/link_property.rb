class LinkProperty
  def initialize(data)
    @data = data || {}
  end

  def name
    @data[:name]
  end

  def value
    @data[:value]
  end
end
