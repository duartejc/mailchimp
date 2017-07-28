defmodule Mailchimp.ListTest do
  use Mailchimp.ResponseMockCase

  alias Mailchimp.{Account, List, Member}

  doctest List

  describe "create_member/5" do
    @tag response_mocks: %{
      {:get, "/"} => {200, "fUA6qoeH-DhFPD23FvGRMw"},
      {:get, "/lists"} => {200, "l54IYCxmxv7wSmiBVJCzKg"},
      {:get, "/lists/42e99f9b48/members"} => {200, "kl-_QUXphCoTRCdZdw0rJw"},
      {:post, "/lists/42e99f9b48/members"} => {200, "IoJAHZtqcwczHEFEMo5G6w"},
    }
    test "returns list success", %{response_mocks: response_mocks} do
      with_response_mocks response_mocks do
        account = Account.get!()
        [list] = Account.lists!(account)
        {:ok, member = %Member{status: :subscribed, merge_fields: %{LNAME: "Test"}, language: "de"}}
          = List.create_member(list, "mailchimp1-test@elixir.com", :subscribed, %{LNAME: "Test"}, %{language: "de"})
        %Member{} = List.create_member!(list, "mailchimp1-test@elixir.com", :subscribed, %{LNAME: "Test"}, %{language: "de"})
      end
    end
  end
end
