class GithubResponse
  GITHUB_API = "https://api.github.com"
  attr_reader :raw, :name

  def self.from(raw, name="root")
    klass = raw.is_a?(Array) ? GithubResponseCollection : GithubResponse

    klass.new(raw, name)
  end

  def initialize(raw, name="root")
    @raw, @name = raw, name
  end

  def attributes
    raw.select{|k,v| attribute?(k,v)}
  end

  def nestings
    raw.
      select{|_,v| nesting?(v)}.
      map{|name,v| self.class.from(v, name) }
  end

  def non_self_links
    links.reject{|name,_| name == "self"}
  end

  def links
    @linnks ||= raw.
      select{|k,_| url?(k)}.
      map{|name,href| format_url_and_key(name,href) }
  end

  def self_link
    @self_link ||= links.find{|name,_| name == "self"}
  end

  def self_link_href
    @self_link_href ||= self_link.try(:last).try(:expand)
  end

  private

  def attribute?(k,v)
    !url?(k) && !nesting?(v)
  end

  def nesting?(v)
    v.is_a?(Hash) || array_of_hashes?(v)
  end

  def array_of_hashes?(v)
    v.is_a?(Array) && v.all?{|i| i.is_a?(Hash)}
  end

  def url?(key)
    key =~ /url$/
  end

  def format_url_and_key(name, href)
    if href && href[GITHUB_API]
      href = href.gsub(GITHUB_API, "")
      template = URITemplate.new(href)
    end
    name = name.gsub(/url|_url/, "").gsub(/\.$/, "")
    name = "self" if name.blank?


    [name, template]
  end


end
