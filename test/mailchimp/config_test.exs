defmodule Mailchimp.ConfigTest do
  use ExUnit.Case

  alias Mailchimp.Config

  describe "api_key!/0" do
    test "should update api_key" do
      Application.put_env(:mailchimp, :api_key, "your apikey-us12")
      assert Config.api_key!() == "your apikey-us12"
      Application.delete_env(:mailchimp, :api_key)
    end
  end

  describe "api_version/0" do
    test "should have a default api version" do
      assert Config.api_version() == "3.0"
    end

    test "should update api version" do
      Application.put_env(:mailchimp, :api_version, "1.0")
      assert Config.api_version() == "1.0"
      Application.delete_env(:mailchimp, :api_version)
    end
  end

  describe "api_endpoint/0" do
    test "should have a default endpoint" do
      assert Config.api_endpoint() == "api.mailchimp.com"
    end

    test "should update the default endpoint" do
      Application.put_env(:mailchimp, :api_endpoint, "api.mc.local")
      assert Config.api_endpoint() == "api.mc.local"
      Application.delete_env(:mailchimp, :api_endpoint)
    end
  end

  describe "shard!/0" do
    test "should return the shard" do
      Application.put_env(:mailchimp, :api_key, "your apikey-us12")
      assert Config.shard!() == "us12"
      Application.delete_env(:mailchimp, :api_key)
    end
  end

  describe "root_endpoint!/0" do
    test "should return the root endpoint" do
      Application.put_env(:mailchimp, :api_key, "your apikey-us12")
      assert Config.root_endpoint!() == "https://us12.api.mailchimp.com/3.0/"
      Application.delete_env(:mailchimp, :api_key)
    end
  end
end
