defmodule Mailchimp.List do
  alias HTTPoison.{Error, Response}
  alias Mailchimp.HTTPClient
  alias Mailchimp.Link
  alias Mailchimp.Member
  alias Mailchimp.List.InterestCategory

  defstruct id: nil,
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

  def members(%__MODULE__{links: %{"members" => %Link{href: href}}}, query_params) do
    case HTTPClient.get(href, [], params: query_params) do
      {:ok, %Response{status_code: 200, body: body}} ->
        {:ok, Enum.map(body.members, &Member.new(&1))}

      {:ok, %Response{status_code: _, body: body}} ->
        {:error, body}

      {:error, %Error{reason: reason}} ->
        {:error, reason}
    end
  end

  def members!(list, query_params \\ %{}) do
    {:ok, members} = members(list, query_params)
    members
  end

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

  def get_member!(list, email) do
    {:ok, member} = get_member(list, email)
    member
  end

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

  def interest_categories(%__MODULE__{links: %{"interest-categories" => %Link{href: href}}}) do
    {:ok, response} = HTTPClient.get(href)

    case response do
      %Response{status_code: 200, body: body} ->
        {:ok, Enum.map(body.categories, &InterestCategory.new(&1))}

      %Response{status_code: _, body: body} ->
        {:error, body}
    end
  end

  def interest_categories!(list) do
    {:ok, categories} = interest_categories(list)
    categories
  end

  def create_member(
        %__MODULE__{links: %{"members" => %Link{href: href}}},
        email_address,
        status,
        merge_fields \\ %{},
        additional_data \\ %{}
      )
      when is_binary(email_address) and is_map(merge_fields) and
             status in [:subscribed, :pending, :unsubscribed, :cleaned] do
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

        case HTTPClient.post(href, Poison.encode!(data)) do
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

  def create_member!(list, email_address, status, merge_fields \\ %{}, additional_data \\ %{}) do
    {:ok, member} = create_member(list, email_address, status, merge_fields, additional_data)
    member
  end

  defp md5(string) do
    :crypto.hash(:md5, string)
    |> Base.encode16()
  end
end
