defmodule Mailchimp.HTTPClient do
  use HTTPoison.Base

  alias Mailchimp.Config

  def process_url(url) do
    Config.root_endpoint <> url
  end

  def process_response_body(body) do
    Poison.decode!(body, keys: :atoms)
  end

  def process_request_headers(headers) do
    encoded_api = Base.encode64(":#{Config.api_key}")

    headers
    |> Enum.into(%{})
    |> Map.put("Authorization", "Basic #{encoded_api}")
    |> Enum.into([])
  end
end
