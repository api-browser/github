class GithubResponseCollection < Array
  include Linkable
  attr_reader :name, :self_link

  def initialize(responses, name, link_header="")
    @name = name
    @raw = responses
    @raw_link_header = link_header
    super responses.map{|r| GithubResponse.new(r)}
  end

end
