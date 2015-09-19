defmodule Mailchimp.HTTPClient do
  use HTTPoison.Base

  alias Mailchimp.Config

  def process_url(url) do
    root_endpoint = Config.root_endpoint
    if String.starts_with?(url, root_endpoint) do
      url
    else
      root_endpoint <> url
    end
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
