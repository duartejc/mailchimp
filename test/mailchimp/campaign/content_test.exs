defmodule Mailchimp.Campaign.COntentTest do
  use Mailchimp.ResponseMockCase

  alias Mailchimp.Campaign
  alias Mailchimp.Campaign.Content

  doctest Campaign

  describe "update/2" do
    @tag response_mocks: %{
      {:get, "/campaigns"} => {200, "toulyoptk6sAYFd8xT-JVQ"},
      {:get, "/campaigns/5f172727ff/content"} => {200, "iC8Je_U6gTkcF2CFP6aLng"},
      {:put, "/campaigns/1d2a9a036a/content"} => {200, "N88dy3B7lsYeqRoIk2-LJA"},
    }
    test "returns campaigns", %{response_mocks: response_mocks} do
      with_response_mocks response_mocks do
        assert [campaign] = Campaign.list!()
        assert content = Campaign.content!(campaign)
        assert {:ok, %Content{}} = Content.update(content, %{template: %{id: 23827, sections: %{content: "Fooooobar"}}})
        assert %Content{} = Content.update!(content, %{template: %{id: 23827, sections: %{content: "Fooooobar"}}})
      end
    end
  end
end
