defmodule Mailchimp.List do
  alias Mailchimp.HTTPClient
  alias Mailchimp.Link

  defstruct id: nil, name: nil, contact: nil, permission_reminder: nil, use_archive_bar: nil, campaign_defaults: nil, notify_on_subscribe: nil, notify_on_unsubscribe: nil, list_rating: nil, email_type_option: nil, subscribe_url_short: nil, subscribe_url_long: nil, beamer_address: nil, visibility: nil, modules: [], stats: nil, links: []

  def new(attributes) do
    %__MODULE__{
      id: attributes[:id],
      name: attributes[:name],
      contact: attributes[:contact],
      permission_reminder: attributes[:permission_reminder],
      use_archive_bar: attributes[:use_archive_bar],
      campaign_defaults: attributes[:campaign_defaults],
      notify_on_subscribe: attributes[:notify_on_subscribe],
      notify_on_unsubscribe: attributes[:notify_on_unsubscribe],
      list_rating: attributes[:list_rating],
      email_type_option: attributes[:email_type_option],
      subscribe_url_short: attributes[:subscribe_url_short],
      subscribe_url_long: attributes[:subscribe_url_long],
      beamer_address: attributes[:beamer_address],
      visibility: attributes[:visibility],
      modules: attributes[:modules],
      stats: attributes[:stats],
      links: Link.get_links_from_attributes(attributes)
    }
  end
end
