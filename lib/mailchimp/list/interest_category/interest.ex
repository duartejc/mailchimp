defmodule Mailchimp.List.InterestCategory.Interest do
  alias Mailchimp.Link

  @moduledoc """

  Manage interests for a specific Mailchimp list.
  Assign subscribers to interests to group them together.
  Interests are referred to as 'group names' in the Mailchimp application.

  ### Struct Fields

    * `id` - The ID for the interest.

    * `category_id` - The id for the interest category.

    * `list_id` - The ID for the list that this interest belongs to.

    * `name` - The name of the interest. This can be shown publicly on a subscription form.

    * `display_order` - The display order for interests.

    * `subscriber_count` - The number of subscribers associated with this interest.

    * `links` - A list of `Mailchimp.Link` types and descriptions for the API schema documents.
  """

  defstruct [
    :id,
    :category_id,
    :list_id,
    :name,
    :display_order,
    :subscriber_count,
    :links
  ]

  @doc """
    Generates an `Mailchimp.List.InterestCategory.Interest` struct from the given attributes.
  """
  def new(attributes) do
    %__MODULE__{
      id: attributes[:id],
      category_id: attributes[:category_id],
      list_id: attributes[:list_id],
      name: attributes[:name],
      display_order: attributes[:display_order],
      subscriber_count: attributes[:subscriber_count],
      links: Link.get_links_from_attributes(attributes)
    }
  end
end
