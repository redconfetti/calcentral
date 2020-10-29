class Link
  attr_accessor :parameters

  def initialize(data, parameters = {})
    @data = data || {}
    @parameters = parameters || {}
  end

  def id
    @data[:urlId]
  end

  def name
    @data[:description]
  end

  def title
    @data[:hoverOverText]
  end

  def url
    url_with_parameters
  end

  def comments
    @data[:comments]
  end

  def properties
    @properties ||= LinkProperties.new(@data[:properties])
  end

  def show_new_window?
    property_value('NEW_WINDOW') == 'Y'
  end

  def uc_from
    property_value('UCFROM')
  end

  def uc_from_link
    property_value('UCFROMLINK')
  end

  def uc_from_text
    property_value('UCFROMTEXT')
  end

  def is_campus_solutions_link?
    property_value('URI_TYPE') == 'PL'
  end

  def update_cache
    property_value('CC_CACHE')
  end

  def as_json(options={})
    {
      urlId: id,
      ucFrom: uc_from,
      ucFromLink: uc_from_link,
      ucFromText: uc_from_text,
      name: name,
      title: title,
      url: url,
      comments: comments,
      showNewWindow: show_new_window?,
      isCampusSolutionsLink: is_campus_solutions_link?,
      ucUpdateacache: update_cache,
    }
  end

  private

  def url_with_parameters
    if parameters.to_h.keys.any?
      parameters.to_a.inject(url_template.dup) do |temporary_url, param|
        temporary_url = temporary_url.gsub("{#{param[0]}}", param[1]) if param[1].present?
        Rails.logger.debug "Could not set url parameter #{param[1]} on link id #{id}" if param[1].blank?
        temporary_url
      end
    else
      url_template
    end
  end

  def property_value(name)
    properties.find_by_name(name)&.value
  end

  def url_template
    @data[:url]
  end
end
