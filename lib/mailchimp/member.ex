defmodule Mailchimp.Member do
  alias Mailchimp.Link
  alias HTTPoison.Response
  alias Mailchimp.HTTPClient

  defstruct email_address: nil,
            email_client: nil,
            email_type: nil,
            id: nil,
            ip_opt: nil,
            ip_signup: nil,
            language: nil,
            last_changed: nil,
            list_id: nil,
            location: nil,
            member_rating: nil,
            merge_fields: nil,
            stats: nil,
            status: nil,
            status_if_new: nil,
            timestamp_opt: nil,
            timestamp_signup: nil,
            unique_email_id: nil,
            vip: nil,
            links: nil,
            tags: []

  def new(attributes) do
    %__MODULE__{
      email_address: attributes[:email_address],
      email_client: attributes[:email_client],
      email_type: attributes[:email_type],
      id: attributes[:id],
      ip_opt: attributes[:ip_opt],
      ip_signup: attributes[:ip_signup],
      language: attributes[:language],
      last_changed: attributes[:last_changed],
      list_id: attributes[:list_id],
      location: attributes[:location],
      member_rating: attributes[:member_rating],
      merge_fields: attributes[:merge_fields],
      stats: attributes[:stats],
      status: attributes[:status],
      status_if_new: attributes[:status_if_new],
      timestamp_opt: attributes[:timestamp_opt],
      timestamp_signup: attributes[:timestamp_signup],
      unique_email_id: attributes[:unique_email_id],
      vip: attributes[:vip],
      links: Link.get_links_from_attributes(attributes),
      tags: attributes[:tags]
    }
  end

  def update(user = %__MODULE__{links: %{"upsert" => %Link{href: href}}}) do
    attrs =
      user
      |> Map.delete(:links)
      |> Map.delete(:__struct__)

    {:ok, response} = HTTPClient.put(href, Jason.encode!(attrs))

    case response do
      %Response{status_code: 200, body: body} ->
        {:ok, new(body)}

      %Response{status_code: _, body: body} ->
        {:error, body}
    end
  end

  def update!(user) do
    {:ok, user} = update(user)
    user
  end
end
