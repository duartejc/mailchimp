defmodule Mailchimp.List.InterestCategory do
  alias Mailchimp.Link

  defstruct [:id, :list_id, :title, :display_order, :type, :links]

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
end
