defmodule Mailchimp.CampaignTest do
  use Mailchimp.ResponseMockCase

  alias Mailchimp.Campaign
  alias Mailchimp.Campaign.Content

  doctest Campaign

  describe "list/0" do
    @tag response_mocks: %{
      {:get, "/campaigns"} => {200, "toulyoptk6sAYFd8xT-JVQ"},
    }
    test "returns campaigns", %{response_mocks: response_mocks} do
      with_response_mocks response_mocks do
        assert {:ok, [%Campaign{}]} = Campaign.list()
        assert [%Campaign{}] = Campaign.list!()
      end
    end
  end

  describe "content/1" do
    @tag response_mocks: %{
      {:get, "/campaigns"} => {200, "toulyoptk6sAYFd8xT-JVQ"},
      {:get, "/campaigns/5f172727ff/content"} => {200, "iC8Je_U6gTkcF2CFP6aLng"},
    }
    test "returns campaigns", %{response_mocks: response_mocks} do
      with_response_mocks response_mocks do
        assert [campaign] = Campaign.list!()
        assert {:ok, %Content{}} = Campaign.content(campaign)
        assert %Content{} = Campaign.content!(campaign)
      end
    end
  end

  describe "create/2" do
    @tag response_mocks: %{
      {:post, "/campaigns"} => {200, "8LbTn0i-ByFekqvUAHWBfw"},
    }
    test "returns campaigns", %{response_mocks: response_mocks} do
      with_response_mocks response_mocks do
        assert {:ok, %Campaign{type: :regular}} = Campaign.create(:regular)
        assert %Campaign{type: :regular} = Campaign.create!(:regular)
      end
    end
  end
end
