defmodule Mailchimp.HTTPClient do

  def get(url, header) do
    case HTTPoison.get(url, header) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        process_response_body body
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        "Not found :("
      {:error, %HTTPoison.Error{reason: reason}} ->
        reason
    end
  end

  def post(url, body, header) do
    case HTTPoison.post(url, body, header) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        process_response_body body
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        "Not found :("
      {:error, %HTTPoison.Error{reason: reason}} ->
        reason
    end
  end

  def process_response_body(body) do
    body
    |> Poison.decode!
    |> Enum.map(fn({k, v}) -> {String.to_atom(k), v} end)
  end

end
