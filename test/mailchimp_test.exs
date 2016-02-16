defmodule MailchimpTest do
  use ExUnit.Case

  test "if mailchimp apikey config exists" do
    prop = Application.get_env(:mailchimp, :apikey)
    assert false == is_nil prop
  end

  test "if apikey contains the server name" do
    len = Application.get_env(:mailchimp, :apikey)
    |> String.split(~r{-})
    |> length
    assert len == 2
  end

end
