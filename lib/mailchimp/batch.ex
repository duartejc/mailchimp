defmodule Mailchimp.Batch do
  alias HTTPoison.Response
  alias Mailchimp.HTTPClient

  @moduledoc """
    Use batch operations to complete multiple operations with a single call.
  """

  @doc """
    Begin processing a batch operations request.
  """
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

  @doc """
    Get the status of a batch request.
  """
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
  @doc """
    Get a summary of batch requests that have been made.
  """
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

  @doc """
    Stops a batch request from running. Since only one batch request is run at a time, this can be used to cancel a long running request.
    The results of any completed operations will not be available after this call.
  """
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
