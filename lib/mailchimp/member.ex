defmodule Mailchimp.Member do
  alias Mailchimp.Link
  alias HTTPoison.{Error, Response}
  alias Mailchimp.HTTPClient

  @moduledoc """

  Manage members of a specific Mailchimp list, including currently subscribed, unsubscribed, and bounced members.

  ### Struct Fields

    * `email_address` - Email address for a subscriber.

    * `email_client` - The list member's email client.

    * `email_type` - Type of email this member asked to get ('html' or 'text').

    * `id` - The MD5 hash of the lowercase version of the list member's email address.

    * `ip_opt` - The IP address the subscriber used to confirm their opt-in status.

    * `ip_signup` - TIP address the subscriber signed up from.

    * `language` - If set/detected, the subscriber's [language](https://mailchimp.com/help/view-and-edit-contact-languages/).

    * `last_changed` - The date and time the member's info was last changed in ISO 8601 format.

    * `list_id` - The list id.

    * `location` - Subscriber location information.

    * `member_rating` - Star rating for this member, between 1 and 5.

    * `merge_fields` - A dictionary of merge fields where the keys are the merge tags. See the [Merge Fields](https://mailchimp.com/developer/marketing/docs/merge-fields/#structure) documentation for more about the structure.

    * `stats` - Open and click rates for this subscriber.

    * `status` - Subscriber's current status. Possible values: "subscribed", "unsubscribed", "cleaned", "pending", "transactional", or "archived".

    * `status_if_new` - Subscriber's status. This value is required only if the email address is not already present on the list.

    * `timestamp_opt` - The date and time the subscribe confirmed their opt-in status in ISO 8601 format.

    * `timestamp_signup` - The date and time the subscriber signed up for the list in ISO 8601 format.

    * `unique_email_id` - An identifier for the address across all of Mailchimp.

    * `vip` - [VIP status](https://mailchimp.com/help/designate-and-send-to-vip-contacts/) for subscriber.

    * `links` - A list of `Mailchimp.Link` types and descriptions for the API schema documents.

    * `tags` - Returns up to 50 tags applied to this member.

  """

  defstruct [
    email_address: nil,
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
  ]

  @doc """
    Generates an `Mailchimp.Member` struct from the given attributes.
  """
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

  @doc """
    Updates the member in Mailchimp
  """
  def update(user = %__MODULE__{links: %{"upsert" => %Link{href: href}}}) do
    attrs =
      user
      |> Map.delete(:links)
      |> Map.delete(:__struct__)

    case HTTPClient.put(href, Jason.encode!(attrs)) do
      {:ok, %Response{status_code: 200, body: body}} ->
        {:ok, new(body)}

      {:ok, %Response{status_code: _, body: body}} ->
        {:error, body}

      {:error, %Error{reason: reason}} ->
        {:error, reason}
    end
  end

  @doc """
    Same as `update/1`
    but raises errors.
  """
  def update!(user) do
    {:ok, user} = update(user)
    user
  end

  @doc """
    Updates the member tages in Mailchimp
  """
  def update_tags(user = %__MODULE__{links: %{"update" => %Link{href: href}}, tags: tags})
      when is_list(tags) do
    attrs = %{tags: tags}

    case HTTPClient.post(href <> "/tags", Jason.encode!(attrs)) do
      {:ok, %Response{status_code: 204, body: _body}} ->
        {:ok, user}

      {:ok, %Response{status_code: _, body: body}} ->
        {:error, body}

      {:error, %Error{reason: reason}} ->
        {:error, reason}
    end
  end

  @doc """
    Same as `update_tags/2`
    but raises errors.
  """
  def update_tags!(user) do
    {:ok, user} = update_tags(user)
    user
  end

  @doc """
    Deletes the member in Mailchimp
  """
  def delete(%__MODULE__{links: %{"delete" => %Link{href: href}}}) do
    {:ok, %HTTPoison.Response{status_code: status_code}} = HTTPClient.delete(href)

    {:ok, status_code}
  end

  @doc """
    Adds event to the member in Mailchimp
  """
  def add_event(
        user = %__MODULE__{links: %{"events" => %Link{href: href}}},
        name,
        optional_parameters \\ %{}
      ) do
    attrs =
      Map.merge(
        %{name: name},
        optional_parameters
      )

    case HTTPClient.post(href, Jason.encode!(attrs)) do
      {:ok, %Response{status_code: 204, body: _body}} ->
        {:ok, user}

      {:ok, %Response{status_code: _, body: body}} ->
        {:error, body}

      {:error, %Error{reason: reason}} ->
        {:error, reason}
    end
  end

  @doc """
    Same as `add_event/2`
    but raises errors.
  """
  def add_event!(user, name, optional_parameters \\ %{}) do
    {:ok, user} = add_event(user, name, optional_parameters)
    user
  end
end
