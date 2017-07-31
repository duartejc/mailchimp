defmodule Mailchimp.ResponseMockCase do
  @moduledoc """
  This module defines the test case to be used by
  response mock tests.
  """

  use ExUnit.CaseTemplate
  alias HTTPoison.Response

  using do
    quote do
      import Mock
      alias Mailchimp.HTTPClient

      defmacro with_response_mocks(mocks, do: test_block) do
        quote do
          Mock.with_mock Mailchimp.HTTPClient, [:passthrough], unquote(mocks), do: unquote(test_block)
        end
      end
    end
  end

  setup tags do
    responses = Map.get(tags, :response_mocks, [])
    |> Enum.map(fn {clause, {status_code, id}} ->
      {clause, %Response{status_code: status_code, body: Mailchimp.MockServer.get(id)}}
    end)
    |> Enum.reduce(%{}, fn {{method, url}, response}, acc ->
      url = clean_url(url)
      Map.update(acc, method, %{url => response}, fn method_responses ->
        Map.put(method_responses, url, response)
      end)
    end)

    response_mocks = [
      get: fn(url) ->
        url = clean_url(url)
        case responses[:get][url] do
          nil ->
            {:error, "Mock for GET #{url} not defined"}
          response ->
            {:ok, response}
        end
      end,
      post: fn(url, data) ->
        url = clean_url(url)
        case responses[:post][url] do
          nil ->
            {:error, "Mock for POST #{url} not defined"}
          response ->
            {:ok, response}
        end
      end,
      put: fn(url, data) ->
        url = clean_url(url)
        case responses[:put][url] do
          nil ->
            {:error, "Mock for PUT #{url} not defined"}
          response ->
            {:ok, response}
        end
      end,
    ]

    reset_config()

    {:ok, %{response_mocks: response_mocks}}
  end

  defp clean_url("/" <> url), do: URI.parse(url).path
  defp clean_url("http" <> url) do
    url = clean_url(URI.parse(url).path)
    [_version, url] = String.split(url, "/", parts: 2)
    url
  end
  defp clean_url(url), do: URI.parse(url).path

  defp reset_config do
    Application.delete_env(:mailchimp, :api_version)
    api_key = System.get_env("MAILCHIMP_TEST_API_KEY") || raise "Specify MAILCHIMP_TEST_API_KEY"
    Application.put_env(:mailchimp, :api_key, api_key)
  end
end
