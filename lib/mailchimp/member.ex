defmodule Mailchimp.Member do
  alias Mailchimp.Link

  defstruct email_address: nil, email_client: nil, email_type: nil, id: nil, ip_opt: nil, ip_signup: nil, language: nil, last_changed: nil, list_id: nil, location: nil, member_rating: nil, merge_fields: nil, stats: nil, status: nil, status_if_new: nil, timestamp_opt: nil, timestamp_signup: nil, unique_email_id: nil, vip: nil, links: nil

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
      status: String.to_atom(attributes[:status]),
      status_if_new: attributes[:status_if_new],
      timestamp_opt: attributes[:timestamp_opt],
      timestamp_signup: attributes[:timestamp_signup],
      unique_email_id: attributes[:unique_email_id],
      vip: attributes[:vip],
      links: Link.get_links_from_attributes(attributes)
    }
  end
end
