defmodule Mailchimp.List do
  import Mailchimp.HTTPClient

  def get_all(config) do
    map_header = %{"Authorization" => "apikey #{config.apikey}"}
    config.apiroot
    |> build_url
    |> get(map_header)
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

end
