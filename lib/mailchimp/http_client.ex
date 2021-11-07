defmodule Mailchimp.HTTPClient do
  @moduledoc """
  Poison HTTP Client for Mailchimp.
  """

  use HTTPoison.Base

  alias Mailchimp.Config

  @doc """
  Complete / Filter URL.

  ### Examples

      iex> Application.put_env(:mailchimp, :api_key, "your apikey-us12")
      iex> Application.delete_env(:mailchimp, :api_version)
      iex> Mailchimp.HTTPClient.process_request_url("test")
      "https://us12.api.mailchimp.com/3.0/test"

      iex> Application.put_env(:mailchimp, :api_key, "your apikey-us12")
      iex> Application.delete_env(:mailchimp, :api_version)
      iex> Mailchimp.HTTPClient.process_request_url("https://us12.api.mailchimp.com/3.0/test")
      "https://us12.api.mailchimp.com/3.0/test"

  """

  def process_request_url(url) do
    root = Config.root_endpoint!()

    cond do
      String.starts_with?(url, root) ->
        url

      String.starts_with?(url, "/") ->
        "/" <> splitted_url = url
        root <> splitted_url

      true ->
        root <> url
    end
  end

  def process_response_body(body) do
    if body === "" do
      body
    else
      Jason.decode!(body, keys: :atoms)
    end
  end

  @doc """
  Add Auth Header to every request that has none already.

  ### Examples

      iex> Application.put_env(:mailchimp, :api_key, "your apikey-us12")
      iex> Mailchimp.HTTPClient.process_request_headers([])
      [{"Authorization", "Basic your apikey-us12"}]

  """
  def process_request_headers(headers) do
    [{"Authorization", "Basic #{Config.api_key!()}"} | headers]
  end
end
