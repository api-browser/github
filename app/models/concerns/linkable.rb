module Linkable
  GITHUB_API = "https://api.github.com"
  attr_reader :raw

  def header_links
    HeaderLinks.parse(@raw_link_header)
  end

  def non_self_links
    links.reject{|name,_| name == "self"}
  end

  def links
    @links ||= uniq(raw.
      select{|k,_| url?(k)}.
      map{|name,href| format_url_and_key(name,href) } +
      _links +
      header_links)
  end

  def uniq(links)
    links.uniq{|a,b| [a,b.try(:pattern)]}
  end

  def attributes
    raw.select{|k,v| k!="_links" && attribute?(k,v)}
  end

  def attribute?(k,v)
    !url?(k) && !nesting?(k,v)
  end

  def _links
    @_links ||= Array(raw["_links"]).
      map{|name,href| format_url_and_key(name,href) }
  end

  def self_link
    @self_link ||= links.find{|name,_| name == "self"}
  end

  def self_link_href
    @self_link_href ||= self_link.try(:last).try(:expand)
  end

  def url?(key)
    key =~ /url$/
  end

  def format_url_and_key(name, href)
    if href
      href = href.gsub(GITHUB_API, "")
      template = URITemplate.new(href)
    end

    name = name.gsub(/url|_url/, "").gsub(/\.$/, "")
    name = "self" if name.blank?


    [name, template]
  end

  class HeaderLinks
    def self.parse(s)
      new(s).parse
    end

    def initialize(raw)
      @raw = raw || ""
    end

    def parse
      links_and_urls.map{|url,rel| [format_rel(rel), format_url(url)]}
    end

    private

    def links_and_urls
      links.map{|s| s.split("\;")}
    end

    def links
      @raw.split(",")
    end

    def format_url(url)
      url.gsub! GITHUB_API, ""
      URITemplate.new url.strip.gsub(/^<|>$/,"")
    end

    def format_rel(rel)
      rel.strip[/".*"/].gsub(/^"|"$/,"")
    end
  end
end

