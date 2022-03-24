defmodule Mailchimp.List.InterestCategory do
  alias Mailchimp.Link
  alias HTTPoison.Response
  alias Mailchimp.HTTPClient
  alias Mailchimp.List.InterestCategory.Interest
  @moduledoc """

  Manage interest categories for a specific list.
  Interest categories organize interests, which are used to group subscribers based on their preferences.
  These correspond to 'group titles' in the Mailchimp application.

  ### Struct Fields

    * `id` - The unique list id for the category.

    * `list_id` - This property contains a fully-qualified URL that can be called to retrieve the linked resource or perform the linked action.

    * `title` - The text description of this category. This field appears on signup forms and is often phrased as a question.

    * `display_order` - The order that the categories are displayed in the list. Lower numbers display first.

    * `type` - Determines how this category’s interests appear on signup forms. Possible values: "checkboxes", "dropdown", "radio", or "hidden".

    * `links` - A list of `Mailchimp.Link` types and descriptions for the API schema documents.
  """

  defstruct [
    :id,
    :list_id,
    :title,
    :display_order,
    :type,
    :links
  ]

  @doc """
    Generates an `Mailchimp.List.InterestCategory` struct from the given attributes.
  """
  def new(attributes) do
    %__MODULE__{
      id: attributes[:id],
      list_id: attributes[:list_id],
      title: attributes[:title],
      display_order: attributes[:display_order],
      type: attributes[:type],
      links: Link.get_links_from_attributes(attributes)
    }
  end

  @doc """
    Fetches all `Mailchimp.List.InterestCategory.Interest` for the given interest category.
  """
  def interests(%__MODULE__{links: %{"interests" => %Link{href: href}}}) do
    {:ok, response} = HTTPClient.get(href)

    case response do
      %Response{status_code: 200, body: body} ->
        {:ok, Enum.map(body.interests, &Interest.new(&1))}

      %Response{status_code: _, body: body} ->
        {:error, body}
    end
  end

  @doc """
    Same as `interests/1`
    but raises errors.
  """
  def interests!(category) do
    {:ok, interests} = interests(category)
    interests
  end
end
