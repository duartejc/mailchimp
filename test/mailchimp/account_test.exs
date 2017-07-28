defmodule Mailchimp.AccountTest do
  use Mailchimp.ResponseMockCase

  alias Mailchimp.Account

  doctest Account

  describe "get/0" do
    @tag response_mocks: %{
      {:get, "/"} => {401, "I-Hv11rbeAKSBw5_bmDYTg"},
    }
    test "returns error tuple on error", %{response_mocks: response_mocks} do
      with_response_mocks response_mocks do
        assert {:error, _detail} = Account.get()
        assert_raise(MatchError, fn ->
          Account.get!()
        end)
      end
    end

    @tag response_mocks: %{
      {:get, "/"} => {200, "fUA6qoeH-DhFPD23FvGRMw"},
    }
    test "returns account on success", %{response_mocks: response_mocks} do
      with_response_mocks response_mocks do
        assert {:ok, %Mailchimp.Account{}} = Account.get()
        assert %Mailchimp.Account{} = Account.get!()
      end
    end
  end

  describe "lists/1" do
    @tag response_mocks: %{
      {:get, "/"} => {200, "fUA6qoeH-DhFPD23FvGRMw"},
      {:get, "/lists"} => {200, "l54IYCxmxv7wSmiBVJCzKg"},
    }
    test "returns list success", %{response_mocks: response_mocks} do
      with_response_mocks response_mocks do
        account = Account.get!()
        assert {:ok, [%Mailchimp.List{}]} = Account.lists(account)
        assert [%Mailchimp.List{}] = Account.lists!(account)
      end
    end
  end
end
