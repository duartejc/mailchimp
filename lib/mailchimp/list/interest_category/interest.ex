defmodule Mailchimp.List.InterestCategory.Interest do
  alias Mailchimp.Link

  defstruct [:id, :category_id, :list_id, :name, :display_order, :subscriber_count, :links]

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
