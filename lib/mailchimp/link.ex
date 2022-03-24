defmodule Mailchimp.Link do
  @moduledoc """

  Stores links for a given Entity in Mailchimp's API

  ### Struct Fields

    * `rel` - As with an HTML rel attribute, this describes the type of link.

    * `href` - This property contains a fully-qualified URL that can be called to retrieve the linked resource or perform the linked action.

    * `method` - The HTTP method that should be used when accessing the URL defined in 'href'. Possible values: "GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS", or "HEAD".

    * `schema` - For HTTP methods that can receive bodies (POST and PUT), this is a URL representing the schema that the body should conform to.

    * `target_schema` - For GETs, this is a URL representing the schema that the response should conform to.
  """

  defstruct [
    rel: nil,
    href: nil,
    method: nil,
    schema: nil,
    target_schema: nil
  ]

  @doc """
    Generates an `Mailchimp.Link` struct from the given attributes.
  """
  def new(attributes) do
    %__MODULE__{
      rel: attributes[:rel],
      href: attributes[:href],
      method: attributes[:method],
      schema: attributes[:schema],
      target_schema: attributes[:targetSchema]
    }
  end

  @doc """
    Generates a list of `Mailchimp.Link` structs from the given links.
  """
  def get_links_from_attributes(%{_links: links}) do
    links
    |> Enum.map(&__MODULE__.new(&1))
    |> Enum.map(&{&1.rel, &1})
    |> Enum.into(%{})
  end

  def get_links_from_attributes(_), do: get_links_from_attributes(%{_links: []})
end
