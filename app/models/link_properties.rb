class LinkProperties
  def initialize(data)
    @data = data || []
  end

  def all
    @data.collect {|p| LinkProperty.new(p) }
  end

  def find_by_name(name)
    name_index[name]
  end

  private

  def name_index
    @name_index ||= all.inject({}) do |map, property|
      map[property.name] = property
      map
    end
  end
end
