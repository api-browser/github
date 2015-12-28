class GithubResponse
  include Linkable
  attr_reader :name

  def self.from(raw, name="root", link_header="")
    klass = raw.is_a?(Array) ? GithubResponseCollection : GithubResponse

    klass.new(raw, name, link_header)
  end

  def initialize(raw, name="root", link_header="")
    @raw_link_header = link_header
    @raw, @name = raw, name
  end

  def nestings
    raw.
      select{|k,v| nesting?(k,v)}.
      map{|name,v| self.class.from(v, name) }
  end

  private

  def nesting?(k,v)
    return false if k=="_links"
    v.is_a?(Hash) || array_of_hashes?(v)
  end

  def array_of_hashes?(v)
    v.is_a?(Array) && v.all?{|i| i.is_a?(Hash)}
  end


end
