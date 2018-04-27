defmodule Mailchimp.Template do
  alias HTTPoison.Response
  alias Mailchimp.HTTPClient

  defstruct [
    :id,
    :type,
    :name,
    :drag_and_drop,
    :responsive,
    :category,
    :date_created,
    :created_by,
    :active,
    :folder_id,
    :thumbnail,
    :share_url,
    :links
  ]

  def new(attrs) do
    {:ok, date_created, _} = DateTime.from_iso8601(attrs[:date_created])

    %__MODULE__{}
    |> Map.merge(
      attrs
      |> Map.merge(%{date_created: date_created})
      |> Map.take(Map.keys(%__MODULE__{}))
    )
  end

  def list(params \\ %{}) do
    case HTTPClient.get("/templates", [], params: params) do
      {:ok, %Response{status_code: 200, body: body}} ->
        {:ok, Enum.map(body.templates, &new(&1))}

      {:ok, %Response{body: body}} ->
        {:error, body}

      {:error, error} ->
        {:error, error}
    end
  end

  def get(id, params \\ %{}) do
    case HTTPClient.get("/templates/#{id}", [], params: params) do
      {:ok, %Response{status_code: 200, body: body}} ->
        {:ok, new(body)}

      {:ok, %Response{body: body}} ->
        {:error, body}

      {:error, error} ->
        {:error, error}
    end
  end

  def create(attrs \\ %{}) do
    case HTTPClient.post("/templates", Poison.encode!(attrs)) do
      {:ok, %Response{status_code: 200, body: body}} ->
        {:ok, new(body)}

      {:ok, %Response{body: body}} ->
        {:error, body}

      {:error, error} ->
        {:error, error}
    end
  end
end
