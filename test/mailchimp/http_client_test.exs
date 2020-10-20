defmodule Mailchimp.HTTPClientTest do
  use ExUnit.Case

  alias Mailchimp.HTTPClient

  describe "process_request_url/1" do
    test "should return the whole url" do
      Application.put_env(:mailchimp, :api_key, "your apikey-us12")
      assert HTTPClient.process_request_url("test") == "https://us12.api.mailchimp.com/3.0/test"

      Application.delete_env(:mailchimp, :api_key)
    end

    test "should return the same url" do
      Application.put_env(:mailchimp, :api_key, "your apikey-us12")

      assert HTTPClient.process_request_url("https://us12.api.mailchimp.com/3.0/test") ==
               "https://us12.api.mailchimp.com/3.0/test"

      Application.delete_env(:mailchimp, :api_key)
    end
  end

  describe "process_request_headers/1" do
    test "should set the API key" do
      Application.put_env(:mailchimp, :api_key, "your apikey-us12")

      assert HTTPClient.process_request_headers([]) == [
               {"Authorization", "Basic your apikey-us12"}
             ]

      Application.delete_env(:mailchimp, :api_key)
    end
  end
end
