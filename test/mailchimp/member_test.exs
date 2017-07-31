defmodule Mailchimp.MemberTest do
  use Mailchimp.ResponseMockCase

  alias Mailchimp.{Account, List, Member}

  doctest List

  describe "update/1" do
    @tag response_mocks: %{
      {:get, "/"} => {200, "fUA6qoeH-DhFPD23FvGRMw"},
      {:get, "/lists"} => {200, "l54IYCxmxv7wSmiBVJCzKg"},
      {:get, "/lists/42e99f9b48/members"} => {200, "kl-_QUXphCoTRCdZdw0rJw"},
      {:get, "/lists/42e99f9b48/members/AA4D0693563AA91ED4EE9DB72EFB2DD5"} => {200, "OOia7QoPpmlDBC_HaapOug"},
      {:put, "/lists/42e99f9b48/members/AA4D0693563AA91ED4EE9DB72EFB2DD5"} => {200, "YD9Uw8CMf4lfkYa8bcdBfA"},
    }
    test "updates member", %{response_mocks: response_mocks} do
      with_response_mocks response_mocks do
        account = Account.get!()
        [list] = Account.lists!(account)
        member = List.get_member!(list, "mailchimp1-test@elixir.com")
        {:ok, %Member{language: "en"}} = Member.update(Map.put(member, :language, "en"))
        %Member{language: "en"} = Member.update!(Map.put(member, :language, "en"))
      end
    end
  end
end
