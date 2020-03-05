defmodule Mailchimp.Campaign.ContentTest do
  use ExUnit.Case
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias Mailchimp.Campaign
  alias Mailchimp.Campaign.Content

  doctest Campaign

  setup_all do
    HTTPoison.start()
  end

  describe "update/2" do
    test "updates content" do
      use_cassette "content.update" do
        assert [campaign | _] = Campaign.list!()
        assert content = Campaign.content!(campaign)

        assert {:ok, %Content{}} =
                 Content.update(content, %{
                   template: %{id: 2000122, sections: %{content: "Fooooobar"}}
                 })

        assert %Content{} =
                 Content.update!(content, %{
                   template: %{id: 2000122, sections: %{content: "Fooooobar"}}
                 })
      end
    end
  end
end
