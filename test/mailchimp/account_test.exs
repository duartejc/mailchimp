defmodule Mailchimp.AccountTest do
  use ExUnit.Case
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias Mailchimp.Account

  setup_all do
    Application.put_env(:mailchimp, :api_key, "your apikey-us19")
    HTTPoison.start()
    on_exit(fn -> Application.delete_env(:mailchimp, :api_key) end)
  end

  describe "get/0" do
    test "returns error tuple on error" do
      use_cassette "account.error" do
        assert {:error, _detail} = Account.get("/1234")

        assert_raise(MatchError, fn ->
          Account.get!("/1234")
        end)
      end
    end

    test "returns account on success" do
      use_cassette "account.get" do
        assert {:ok, %Mailchimp.Account{}} = Account.get()
        assert %Mailchimp.Account{} = Account.get!()
      end
    end
  end

  describe "lists/1" do
    test "returns list success" do
      use_cassette "account.lists" do
        account = Account.get!()
        assert {:ok, [%Mailchimp.List{}]} = Account.lists(account)
        assert [%Mailchimp.List{}] = Account.lists!(account)
      end
    end
  end

  describe "get_all_lists/1" do
    test "returns list success" do
      use_cassette "account.lists" do
        assert {:ok, [%Mailchimp.List{}]} = Account.get_all_lists()
        assert [%Mailchimp.List{}] = Account.get_all_lists!()
      end
    end
  end

end
