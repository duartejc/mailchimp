defmodule Mailchimp.List do
  alias HTTPoison.{Error, Response}
  alias Mailchimp.HTTPClient
  alias Mailchimp.Link
  alias Mailchimp.Member
  alias Mailchimp.List.InterestCategory
  @moduledoc """

  Your Mailchimp list, also known as your audience, is where you store and manage all of your contacts.

  ### Struct Fields

    * `id` - A string that uniquely identifies this list.

    * `name` - The name of the list.

    * `permission_reminder` - The  [persmission reminder](https://mailchimp.com/help/edit-the-permission-reminder/) for the list.

    * `campaign_defaults` - Default values for campaigns created for this list.

    * `notify_on_subscribe` - The email address to send subscribe notifications to.

    * `notify_on_unsubscribe` - The email address to send unsubscribe notifications to.

    * `list_rating` - An auto-generated activity score for the list (0-5).

    * `email_type_option` - Whether the list support [multiple formats](https://mailchimp.com/help/change-audience-name-defaults/) for emails. When set to true, subscribers can choose whether they want to receive HTML or plain-text emails. When set to false, subscribers will receive HTML emails, with a plain-text alternative backup.

    * `subscribe_url_short` - url [Link shortened version](https://mailchimp.com/help/share-your-signup-form/) of this list's subscribe form.

    * `subscribe_url_long` - The full version of this list's subscribe form (host will vary).

    * `beamer_address` - The list's [Email Beamer](https://mailchimp.com/help/use-email-beamer-to-create-a-campaign/) address.

    * `visibility` - Legacy. visibility settings are no longer used Possible values: "pub" or "prv".

    * `modules` - Any list-specific modules installed for this list.

    * `stats` - Stats for the list. Many of these are cached for at least five minutes.

    * `links` - A list of `Mailchimp.Link` types and descriptions for the API schema documents.

  """


  defstruct [
    id: nil,
    name: nil,
    contact: nil,
    permission_reminder: nil,
    use_archive_bar: nil,
    campaign_defaults: nil,
    notify_on_subscribe: nil,
    notify_on_unsubscribe: nil,
    list_rating: nil,
    email_type_option: nil,
    subscribe_url_short: nil,
    subscribe_url_long: nil,
    beamer_address: nil,
    visibility: nil,
    modules: [],
    stats: nil,
    links: []
  ]

  @doc """
    Generates an `Mailchimp.List` struct from the given attributes.
  """
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

  @doc """
    Fetches a list of `Mailchimp.Member` of a given list
  """
  def members(%__MODULE__{links: %{"members" => %Link{href: href}}}, query_params \\ %{}) do
    case HTTPClient.get(href, [], params: query_params) do
      {:ok, %Response{status_code: 200, body: body}} ->
        {:ok, Enum.map(body.members, &Member.new(&1))}

      {:ok, %Response{status_code: _, body: body}} ->
        {:error, body}

      {:error, %Error{reason: reason}} ->
        {:error, reason}
    end
  end

  @doc """
    Same as `members/2`
    but raises errors.
  """
  def members!(list, query_params \\ %{}) do
    {:ok, members} = members(list, query_params)
    members
  end


  @doc """
    Fetches all members on the mailchimp list, and compares then to the given list of members.
    Warning: This method only checks for the same email address

    Raises errors on connection failure

  ## Examples
      iex> check_diff_to_mailchimp!(list,[member1])
      %{members_on_mailchimp: [], members_not_on_mailchimp: []}

  """
  def check_diff_to_mailchimp!(list, members) do
    members_on_mailchimp =
      list
      |> members!()

    %{
      members_not_on_mailchimp:
        members
        |> Enum.filter(
          fn member ->
            members_on_mailchimp
            |> Enum.find(
              fn member_on_mail_chimp ->
                member_on_mail_chimp.email_address == member.email_address
              end
            ) == nil
        end),

      members_only_on_mailchimp:
        members_on_mailchimp
        |> Enum.filter(
          fn member ->
            members
            |> Enum.find(
              fn member_on_mail_chimp ->
                member_on_mail_chimp.email_address == member.email_address
              end
            ) == nil
        end)
    }
  end

  @doc """
    Fetches a `Mailchimp.Member` of a given list by it's email
  """
  def get_member(%__MODULE__{links: %{"members" => %Link{href: href}}}, email) do
    subscriber_id =
      email
      |> String.downcase()
      |> md5

    {:ok, response} = HTTPClient.get(href <> "/#{subscriber_id}")

    case response do
      %Response{status_code: 200, body: body} ->
        {:ok, Member.new(body)}

      %Response{status_code: _, body: body} ->
        {:error, body}
    end
  end

  @doc """
    Same as `get_member`
    but raises errors.
  """
  def get_member!(list, email) do
    {:ok, member} = get_member(list, email)
    member
  end

  @doc """
    Sends a request that removes a `Mailchimp.Member` of a given list by it's email
  """
  def destroy_member(%__MODULE__{links: %{"members" => %Link{href: href}}}, email) do
    subscriber_id =
      email
      |> String.downcase()
      |> md5

    {:ok, response} = HTTPClient.delete(href <> "/#{subscriber_id}")

    case response do
      %Response{status_code: 204} ->
        {:ok, email}

      %Response{status_code: _, body: body} ->
        {:error, body}
    end
  end

  @doc """
    Fetches a list of `Mailchimp.List.InterestCategory` of a given list
  """
  def interest_categories(%__MODULE__{links: %{"interest-categories" => %Link{href: href}}}) do
    {:ok, response} = HTTPClient.get(href)

    case response do
      %Response{status_code: 200, body: body} ->
        {:ok, Enum.map(body.categories, &InterestCategory.new(&1))}

      %Response{status_code: _, body: body} ->
        {:error, body}
    end
  end

  @doc """
    Same as `interest_categories`
    but raises errors.
  """
  def interest_categories!(list) do
    {:ok, categories} = interest_categories(list)
    categories
  end

  @doc """
    Creates or updates a member at Mailchimp. You can pass merge_fields or additional_data
  """
  def create_or_update_member(
        %__MODULE__{links: %{"members" => %Link{href: href}}},
        email_address,
        status_if_new,
        merge_fields \\ %{},
        additional_data \\ %{}
      )
      when is_binary(email_address) and is_map(merge_fields) and
             status_if_new in ["subscribed", "pending", "unsubscribed", "cleaned"] do

    subscriber_id =
      email_address
      |> String.downcase()
      |> md5

    data =
      Map.merge(additional_data, %{
        email_address: email_address,
        status_if_new: status_if_new,
        merge_fields: merge_fields
      })

    case HTTPClient.put(href <> "/#{subscriber_id}", Jason.encode!(data)) do
      {:ok, %Response{status_code: 200, body: body}} ->
        {:ok, Member.new(body)}

      {:ok, %Response{status_code: _, body: body}} ->
        {:error, body}

      {:error, error} ->
        {:error, error}
    end
  end

  @doc """
    Same as `create_or_update_member/5`
    but raises errors.
  """
  def create_or_update_member!(list, email_address, status_if_new, merge_fields \\ %{}, additional_data \\ %{}) do
    {:ok, member} = create_or_update_member(list, email_address, status_if_new, merge_fields, additional_data)
    member
  end

  @doc """
    Creates a member at Mailchimp. You can pass merge_fields or additional_data
  """
  def create_member(
        %__MODULE__{links: %{"members" => %Link{href: href}}},
        email_address,
        status,
        merge_fields \\ %{},
        additional_data \\ %{}
      )
      when is_binary(email_address) and is_map(merge_fields) and
             status in ["subscribed", "pending", "unsubscribed", "cleaned"] do
    case HTTPClient.get(href) do
      {:ok, %Response{status_code: 200, body: body}} ->
        links = Link.get_links_from_attributes(body)
        href = links["create"].href

        data =
          Map.merge(additional_data, %{
            email_address: email_address,
            status: status,
            merge_fields: merge_fields
          })

        case HTTPClient.post(href, Jason.encode!(data)) do
          {:ok, %Response{status_code: 200, body: body}} ->
            {:ok, Member.new(body)}

          {:ok, %Response{status_code: _, body: body}} ->
            {:error, body}

          {:error, error} ->
            {:error, error}
        end

      {:ok, %Response{status_code: _, body: body}} ->
        {:error, body}

      {:error, error} ->
        {:error, error}
    end
  end

  @doc """
    Same as `create_member/5`
    but raises errors.
  """
  def create_member!(list, email_address, status, merge_fields \\ %{}, additional_data \\ %{}) do
    {:ok, member} = create_member(list, email_address, status, merge_fields, additional_data)
    member
  end


  @doc """
  Batch subscribe members. Pass the List and the list of members with properties
  such as email_address, status, and merge_fields (for example, for first and last name).
  Additional options can be passed, such as update_existing. See the API docs for details:
  https://mailchimp.com/developer/api/marketing/lists/batch-subscribe-or-unsubscribe/
  """
  def batch_subscribe(
        %__MODULE__{links: %{"self" => %Link{href: href}}},
        members,
        opts \\ %{}
      ) do
    # default options
    opts = Map.merge(%{update_existing: false}, opts)
    members = Enum.map(members, fn member -> Map.merge(%{status: "subscribed"}, member) end)

    data = Map.merge(opts, %{members: members})

    case HTTPClient.post(href, Jason.encode!(data)) do
      {:ok, %Response{status_code: 200, body: body}} ->
        body = body |> map_members(:new_members) |> map_members(:updated_members)
        {:ok, body}

      {:ok, %Response{status_code: _, body: body}} ->
        {:error, body}

      {:error, error} ->
        {:error, error}
    end
  end

  @doc """
    Same as `batch_subscribe`
    but raises errors.
  """
  def batch_subscribe!(list, members, opts \\ %{}) do
    {:ok, members} = batch_subscribe(list, members, opts)
    members
  end


  @doc """
    Creates a list of members at Mailchimp. You can pass merge_fields or additional_data
  """
  def create_members(
        list,
        email_addresses,
        status,
        merge_fields \\ %{},
        additional_data \\ %{}
      ) do
    members =
      for email_address <- email_addresses do
        %{
          email_address: email_address,
          status: status,
          merge_fields: merge_fields
        }
      end

    case batch_subscribe(list, members, additional_data) do
      {:ok, response} ->
        {:ok, response.new_members}

      {:error, error} ->
        {:error, error}
    end
  end

  @doc """
    Same as `create_members/5`
    but raises errors.
  """
  def create_members!(list, email_addresses, status, merge_fields \\ %{}, additional_data \\ %{}) do
    {:ok, members} = create_members(list, email_addresses, status, merge_fields, additional_data)
    members
  end

  defp map_members(body, key) do
    members =
      Map.get(body, key, [])
      |> Enum.map(fn member -> Member.new(member) end)

    Map.put(body, key, members)
  end

  defp md5(string) do
    :crypto.hash(:md5, string)
    |> Base.encode16()
  end
end
