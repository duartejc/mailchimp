defmodule Mailchimp.List do
  import Mailchimp.HTTPClient

  def all(config) do
    map_header = %{"Authorization" => "apikey #{config.apikey}"}
    config.apiroot
    |> build_url
    |> get(map_header)
  end

  def members(config, list_id) do
    map_header = %{"Authorization" => "apikey #{config.apikey}"}
    config.apiroot <> "lists/" <> list_id <> "/members"
    |> get(map_header)
  end

  def get_member(config, %{"list_id" => list_id, "email" => email}) do
    map_header = %{"Authorization" => "apikey #{config.apikey}"}
    lowercase_email = String.downcase(email)
    md5_email = md5(lowercase_email)
    config.apiroot <> "lists/" <> list_id <> "/members/" <> md5_email
    |> get(map_header)
  end

  def add_member(config, %{"list_id" => list_id, "email" => email}) do
    map_header = %{"Authorization" => "apikey #{config.apikey}"}
    {:ok, body} = Poison.encode(%{email_address: email, status: "subscribed"})
    config.apiroot <> "lists/" <> list_id <> "/members"
    |> post(body, map_header)
  end

  def add_pending_member(config, %{"list_id" => list_id, "email" => email}) do
    map_header = %{"Authorization" => "apikey #{config.apikey}"}
    {:ok, body} = Poison.encode(%{email_address: email, status: "pending"})
    config.apiroot <> "lists/" <> list_id <> "/members"
    |> post(body, map_header)
  end

  def remove_member(config, %{"list_id" => list_id, "email" => email}) do
    map_header = %{"Authorization" => "apikey #{config.apikey}"}
    lowercase_email = String.downcase(email)
    md5_email = md5(lowercase_email)
    config.apiroot <> "lists/" <> list_id <> "/members/" <> md5_email
    |> delete(map_header)
  end

  def build_url(root) do
    params = [
      {:fields, ["lists.id", "lists.name", "lists.stats.member_count"]},
      {:count, 10},
      {:offset, 0}
    ]
    fields = "fields=" <> as_string(params[:fields])
    count = "count=" <> to_string params[:count]
    offset = "offset=" <> to_string params[:offset]
    url = root <> "lists?" <> fields <> "&" <> count <> "&" <> offset
  end

  def as_string(param) do
    Enum.reduce(param, fn(s, acc) -> acc<>","<>s end)
  end

  def md5(string) do
    Base.encode16(:erlang.md5(string), case: :lower)
  end

end
