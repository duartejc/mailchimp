defmodule Mailchimp.Batch do
  alias HTTPoison.Response
  alias Mailchimp.HTTPClient

  def create_batch(operations) when is_list(operations) do
    case HTTPClient.post("/batches", Jason.encode!(%{operations: operations})) do
      {:ok, %Response{status_code: 200, body: body}} ->
        {:ok, body}

      {:ok, %Response{status_code: _, body: body}} ->
        {:error, body}

      {:error, error} ->
        {:error, error}
    end
  end

  def create_batch(_operations), do: {:error, "No batch given"}

  def get_batch(batch_id) do
    case HTTPClient.get("/batches/" <> batch_id) do
      {:ok, %Response{status_code: 200, body: body}} ->
        {:ok, body}

      {:ok, %Response{status_code: _, body: body}} ->
        {:error, body}

      {:error, error} ->
        {:error, error}
    end
  end

  def batches(query_params \\ %{}) do
    case HTTPClient.get("/batches", [], params: query_params) do
      {:ok, %Response{status_code: 200, body: body}} ->
        {:ok, body}

      {:ok, %Response{status_code: _, body: body}} ->
        {:error, body}

      {:error, error} ->
        {:error, error}
    end
  end

  def destroy_batch(batch_id) do
    case HTTPClient.delete("/batches/" <> batch_id) do
      {:ok, %Response{status_code: 204, body: body}} ->
        {:ok, body}

      {:ok, %Response{status_code: _, body: body}} ->
        {:error, body}

      {:error, error} ->
        {:error, error}
    end
  end
end
