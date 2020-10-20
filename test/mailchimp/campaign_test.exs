defmodule Mailchimp.CampaignTest do
  use ExUnit.Case
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias Mailchimp.Campaign
  alias Mailchimp.Campaign.Content

  setup_all do
    Application.put_env(:mailchimp, :api_key, "your apikey-us19")
    HTTPoison.start()
    on_exit(fn -> Application.delete_env(:mailchimp, :api_key) end)
  end

  describe "list/0" do
    test "returns campaigns" do
      use_cassette "campaign.list" do
        assert {:ok, [%Campaign{} | _]} = Campaign.list()
        assert [%Campaign{} | _] = Campaign.list!()
      end
    end
  end

  describe "content/1" do
    test "returns campaign content" do
      use_cassette "campaign.list.content" do
        assert [campaign | _] = Campaign.list!()
        assert {:ok, %Content{}} = Campaign.content(campaign)
        assert %Content{} = Campaign.content!(campaign)
      end
    end
  end

  describe "create/2" do
    test "creates campaigns" do
      use_cassette "campaign.create" do
        assert {:ok, %Campaign{type: :regular}} = Campaign.create(:regular)
        assert %Campaign{type: :regular} = Campaign.create!(:regular)
      end
    end
  end
end
