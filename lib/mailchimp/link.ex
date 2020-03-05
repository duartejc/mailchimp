defmodule Mailchimp.Link do
  defstruct rel: nil, href: nil, method: nil, schema: nil, target_schema: nil

  def new(attributes) do
    %__MODULE__{
      rel: attributes[:rel],
      href: attributes[:href],
      method: attributes[:method],
      schema: attributes[:schema],
      target_schema: attributes[:targetSchema]
    }
  end

  def get_links_from_attributes(%{_links: links}) do
    links
    |> Enum.map(&__MODULE__.new(&1))
    |> Enum.map(&{&1.rel, &1})
    |> Enum.into(%{})
  end

  def get_links_from_attributes(_), do: get_links_from_attributes(%{_links: []})
end
