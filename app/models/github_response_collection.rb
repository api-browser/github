class GithubResponseCollection < Array
  attr_reader :name, :self_link

  def initialize(responses, name)
    @name = name
    super responses.map{|r| GithubResponse.new(r)}
  end
end
