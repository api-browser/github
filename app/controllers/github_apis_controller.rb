class GithubApisController < ApplicationController
  def show
    @github_response = GithubResponse.from(json)
  end

  private

  def json
    JSON.parse(github_response)
  end

  def github_response
    path = params[:path]
    response_headers = {"Authorization" => "token #{token}", "User-Agent" => "github_api_browser"}

    HTTParty.get("https://api.github.com/#{path}", headers: response_headers).body
  end

  def token
    File.read("../OAUTH_TOKEN").chomp
  end
end
