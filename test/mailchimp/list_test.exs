defmodule Mailchimp.ListTest do
  use Mailchimp.ResponseMockCase

  alias Mailchimp.{Account, List, Member}
  alias Mailchimp.List.InterestCategory

  doctest List

  describe "create_member/5" do
    @tag response_mocks: %{
      {:get, "/"} => {200, "fUA6qoeH-DhFPD23FvGRMw"},
      {:get, "/lists"} => {200, "l54IYCxmxv7wSmiBVJCzKg"},
      {:get, "/lists/42e99f9b48/members"} => {200, "kl-_QUXphCoTRCdZdw0rJw"},
      {:post, "/lists/42e99f9b48/members"} => {200, "IoJAHZtqcwczHEFEMo5G6w"},
    }
    test "creates member", %{response_mocks: response_mocks} do
      with_response_mocks response_mocks do
        account = Account.get!()
        [list] = Account.lists!(account)
        {:ok, %Member{status: :subscribed, merge_fields: %{LNAME: "Test"}, language: "de"}}
          = List.create_member(list, "mailchimp1-test@elixir.com", :subscribed, %{LNAME: "Test"}, %{language: "de"})
        %Member{} = List.create_member!(list, "mailchimp1-test@elixir.com", :subscribed, %{LNAME: "Test"}, %{language: "de"})
      end
    end
  end

  describe "get_member/5" do
    @tag response_mocks: %{
      {:get, "/"} => {200, "fUA6qoeH-DhFPD23FvGRMw"},
      {:get, "/lists"} => {200, "l54IYCxmxv7wSmiBVJCzKg"},
      {:get, "/lists/42e99f9b48/members"} => {200, "kl-_QUXphCoTRCdZdw0rJw"},
      {:get, "/lists/42e99f9b48/members/AA4D0693563AA91ED4EE9DB72EFB2DD5"} => {200, "OOia7QoPpmlDBC_HaapOug"}
    }
    test "creates member", %{response_mocks: response_mocks} do
      with_response_mocks response_mocks do
        account = Account.get!()
        [list] = Account.lists!(account)
        {:ok, %Member{status: :subscribed, merge_fields: %{LNAME: "Test"}, language: "de"}}
          = List.get_member(list, "mailchimp1-test@elixir.com")
        %Member{} = List.get_member!(list, "mailchimp1-test@elixir.com")
      end
    end
  end

  describe "interest_categories/1" do
    @tag response_mocks: %{
      {:get, "/"} => {200, "fUA6qoeH-DhFPD23FvGRMw"},
      {:get, "/lists"} => {200, "l54IYCxmxv7wSmiBVJCzKg"},
      {:get, "/lists/42e99f9b48/interest-categories"} => {200, "RXfZkdpPw_9nTq0tlz1IZg"},
    }
    test "returns list success", %{response_mocks: response_mocks} do
      with_response_mocks response_mocks do
        account = Account.get!
        [list] = Account.lists!(account)
        {:ok, [%InterestCategory{}]} = List.interest_categories(list)
        [%InterestCategory{}] = List.interest_categories!(list)
      end
    end
  end
end
