require 'rails_helper'

RSpec.describe GithubResponse, type: :model do
  let(:response) do
    {
      "some_attribute" => 1,
      "some_other_attribute" => "a string",
      "a_nested_array_attribute" => [1,2,3],
      "a_nested_array_association" => [
        {"a"=>1,"b"=>2,"c"=>3},
        {"d"=>1,"e"=>2,"f"=>3}
      ],
      "url"   => "https://api.github.com/url",
      "owner" => {
        "a nested attribute" => 0,
        "url"         => "https://api.github.com/owner-url",
        "another_url" => "https://api.github.com/another-url",
        "deeper_nesting" => {"next" => "level"}
      }
    }
  end
  let(:github_response) { GithubResponse.new(response) }

  describe "#attributes" do
    it do
      expect(github_response.attributes).to eq({
        "some_attribute" => 1,
        "some_other_attribute" => "a string",
        "a_nested_array_attribute" => [1,2,3],
      })
    end
  end

  describe "#name" do
    it do
      expect(github_response.name).to eq "root"
    end
  end

  describe "#nestings" do
    it do
      expect(github_response.nestings.map(&:name)).to eq %w(a_nested_array_association owner)
      collection = github_response.nestings.first
      expect(collection).to be_a GithubResponseCollection
      expect(collection.first).to be_a GithubResponse
      expect(collection.first.attributes).to  eq({"a"=>1,"b"=>2,"c"=>3})
      expect(collection.second.attributes).to eq({"d"=>1,"e"=>2,"f"=>3})

      owner = github_response.nestings.second
      expect(owner).to be_a GithubResponse
      expect(owner.attributes).to eq({"a nested attribute" => 0})
      expect(owner.nestings.first.name).to eq("deeper_nesting")
      expect(owner.nestings.first.attributes).to eq({"next" => "level"})
    end
  end

  context "with an array" do
    let(:response) do
      JSON.parse File.read "./spec/support/array_result.rb"
    end
  end


  it "displays links"do
    expect(github_response.links).to eq([["self", "/url"]])
    expect(github_response.nestings.last.links).to eq [
      ["self", "/owner-url"],
      ["another", "/another-url"]
    ]
  end

end
