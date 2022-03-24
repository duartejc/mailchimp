defmodule Mailchimp.Template do
  alias HTTPoison.Response
  alias Mailchimp.HTTPClient
  @moduledoc """
  Manage the Templates in your account.

  Manage members of a specific Mailchimp list, including currently subscribed, unsubscribed, and bounced members.

  ### Struct Fields

    * `id` - The individual id for the template.

    * `type` - The type of template (user, base, or gallery).

    * `name` - The name of the template.

    * `drag_and_drop` - Whether the template uses the drag and drop editor.

    * `responsive` - Whether the template contains media queries to make it responsive.

    * `category` - If available, the category the template is listed in.

    * `date_created` - The date and time the template was created in ISO 8601 format.

    * `created_by` - The login name for template's creator.

    * `active` - User templates are not 'deleted,' but rather marked as 'inactive.' Returns whether the template is still active.

    * `folder_id` - The id of the folder the template is currently in.

    * `thumbnail` - If available, the URL for a thumbnail of the template.

    * `share_url` - The URL used for [template sharing](https://mailchimp.com/help/share-a-template/).

    * `links` - A list of `Mailchimp.Link` types and descriptions for the API schema documents.

  """


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

  @doc """
    Generates an `Mailchimp.Template` struct from the given attributes.
  """
  def new(attrs) do
    {:ok, date_created, _} = DateTime.from_iso8601(attrs[:date_created])

    %__MODULE__{}
    |> Map.merge(
      attrs
      |> Map.merge(%{date_created: date_created})
      |> Map.take(Map.keys(%__MODULE__{}))
    )
  end

  @doc """
    Fetch a list of `Mailchimp.Template` for the given account with optional query params.
  """
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

  @doc """
    Fetch a `Mailchimp.Template` with the given id with optional query params.
  """
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

  @doc """
    Creates `Mailchimp.Template` and sends it to Mailchimp.
  """
  def create(attrs \\ %{}) do
    case HTTPClient.post("/templates", Jason.encode!(attrs)) do
      {:ok, %Response{status_code: 200, body: body}} ->
        {:ok, new(body)}

      {:ok, %Response{body: body}} ->
        {:error, body}

      {:error, error} ->
        {:error, error}
    end
  end
end
