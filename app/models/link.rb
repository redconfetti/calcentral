class Link
  def initialize(data)
    @data = data || {}
  end

  def id
    @data[:urlId]
  end

  def description
    @data[:description]
  end

  def hover_over_text
    @data[:hoverOverText]
  end

  def url
    @data[:url]
  end

  def comments
    @data[:comments]
  end

  def properties
    CampusSolutions::Base::LinkProperties.new(@data[:properties])
  end

  def as_json(options={})
    {
      id: id,
      description: description,
      hoverOverText: hover_over_text,
      properties: properties.as_json,
      url: url,
      comments: comments,
    }
  end
end
