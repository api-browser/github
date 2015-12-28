class GithubApisController < ApplicationController
  def show
    @github_response = GithubResponse.from(json, "root", github_response.headers["link"])
  end

  private

  def json
    JSON.parse(github_response.body)
  end

  def github_response
    @github_response ||= HTTParty.get(github_url, headers: github_request_headers, query: github_request_params)
  end

  def github_url
    "https://api.github.com/#{path}"
  end

  def github_request_headers
    {"Authorization" => "token #{token}", "User-Agent" => "github_api_browser"}
  end

  def github_request_params
    request.query_parameters
  end

  helper_method :path

  def path
    params[:path]
  end

  def token
    ENV["OAUTH_TOKEN"]
  end
end
