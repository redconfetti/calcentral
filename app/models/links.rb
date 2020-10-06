class Links
  # Provides links for the "My Campus" page.
  # Most links are statically defined within public/json/campuslinks.json,
  # however those with 'cs_link_id' keys present have their attributes sourced from
  # the CS Link API.
  def campus_links
    links_json = campus_links_json
    load_cs_link_api_entries(links_json)
  end

  private

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
