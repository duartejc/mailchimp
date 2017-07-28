defmodule Mailchimp.List.InterestCategoryTest do
  use Mailchimp.ResponseMockCase

  alias Mailchimp.{Account, List}
  alias Mailchimp.List.InterestCategory
  alias Mailchimp.List.InterestCategory.Interest

  doctest List

  describe "interests/1" do
    @tag response_mocks: %{
      {:get, "/"} => {200, "fUA6qoeH-DhFPD23FvGRMw"},
      {:get, "/lists"} => {200, "l54IYCxmxv7wSmiBVJCzKg"},
      {:get, "/lists/42e99f9b48/interest-categories"} => {200, "RXfZkdpPw_9nTq0tlz1IZg"},
      {:get, "/lists/42e99f9b48/interest-categories/82ccd9f411/interests"} => {200, "qdUoqwi4SdFY1y2JRTtGpw"},
    }
    test "returns list success", %{response_mocks: response_mocks} do
      with_response_mocks response_mocks do
        account = Account.get!
        [list] = Account.lists!(account)
        [category] = List.interest_categories!(list)
        {:ok, [%Interest{}, %Interest{}]} = InterestCategory.interests(category)
        [%Interest{}, %Interest{}] = InterestCategory.interests!(category)
      end
    end
  end
end
