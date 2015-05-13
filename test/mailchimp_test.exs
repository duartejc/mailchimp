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

  test "it can start application" do
    {status, _} = Mailchimp.start_link([])
    assert :ok == status
  end

  test "it can get shard from apikey" do
    shard = Mailchimp.get_shard
    assert false == is_nil shard
  end
  
end
