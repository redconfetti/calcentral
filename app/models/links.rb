class Links
  def self.find(id, parameters = {})
    if link = Links.new.find(id)
      link.parameters = parameters
      link
    end
  end

  def find(link_id)
    id_hash.fetch(link_id) { nil }
  end

  def all
    @all ||= data.keys.collect do |link_id|
      Link.new(data[link_id])
    end
  end

  # Provides links for the "My Campus" page.
  # Most links are statically defined within public/json/campuslinks.json,
  # however those with 'cs_link_id' keys present have their attributes sourced from
  # the CS Link API.
  def campus_links
    links_json = campus_links_json
    load_cs_link_api_entries(links_json)
  end

  private

  def id_hash
    all.inject({}) do |map, link|
      map[link.id] = link; map
    end
  end

  def data
    @data ||= CampusSolutions::Link.new.get.dig(:feed, :ucLinkResources, :links) || {}
  end

  def load_cs_link_api_entries(links_json)
    links_json['links'].each do |link|
      if link_id = link.try(:[], 'cs_link_id')
        if cs_link = LinkFetcher.fetch_link(link_id)
          link['name'] = cs_link[:name]
          link['hoverText'] = cs_link[:title]
          link['url'] = cs_link[:url]
          if cs_link[:linkDescriptionDisplay]
            link['description'] = cs_link[:linkDescription]
          end
          link.merge!(cs_link)
        end
      end
    end
    links_json
  end

  def campus_links_json
    file = File.open("#{Rails.root}/public/json/campuslinks.json")
    contents = File.read(file)
    JSON.parse(contents)
  end
end
