require 'rails_helper'

RSpec.feature "GetApiEndpoints", type: :feature do
  it "" do
    visit "/repos/leecade/react-native-swiper/forks"
    expect(body).to include <<-BODY.strip_heredoc
[
  {
    "id": 48519280,
    "name": "react-native-swiper",
    "full_name": "loveacat/react-native-swiper",
    "owner": {
      "login": "loveacat",
      "id": 4510619,
      "gravatar_id": "",
      "type": "User",
      "site_admin": false
    },
    BODY

    expect(body).to include %w{<a href="/users/loveacat">owner</a>}
    expect(body).to include %w{<a href="/users/loveacat/followers">followers</a>}
  end
end
