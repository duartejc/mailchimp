defmodule Mailchimp.List.InterestCategoryTest do
  use ExUnit.Case
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias Mailchimp.{Account, List}
  alias Mailchimp.List.InterestCategory
  alias Mailchimp.List.InterestCategory.Interest

  setup_all do
    HTTPoison.start()
  end

  describe "interests/1" do
    test "returns list success" do
      Application.put_env(:mailchimp, :api_key, "your apikey-us19")

      use_cassette "interests" do
        account = Account.get!()
        [list] = Account.lists!(account)
        [category] = List.interest_categories!(list)
        {:ok, [%Interest{} | _]} = InterestCategory.interests(category)
        [%Interest{} | _] = InterestCategory.interests!(category)
      end

      Application.delete_env(:mailchimp, :api_key)
    end
  end
end
