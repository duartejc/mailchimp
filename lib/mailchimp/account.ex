defmodule Mailchimp.Account do
  alias HTTPoison.Response
  alias Mailchimp.HTTPClient
  alias Mailchimp.Link
  alias Mailchimp.List

    @moduledoc """

  Details about the Mailchimp user account.

  ### Struct Fields

    * `account_id` - The Mailchimp account ID.

    * `account_name` - The name of the account.

    * `contact` - Information about the account contact.

    * `last_login` - The date and time of the last login for this account in ISO 8601 format.

    * `total_subscribers` - The total number of subscribers across all lists in the account.

    * `links` - A list of `Mailchimp.Link` types and descriptions for the API schema documents.
  """


  defstruct [
    account_id: nil,
    account_name: nil,
    contact: nil,
    last_login: nil,
    total_subscribers: 0,
    links: []
  ]

  @doc """
    Generates an `Mailchimp.Account` struct from the given attributes.
  """
  def new(attributes) do
    %__MODULE__{
      account_id: attributes[:account_id],
      account_name: attributes[:account_name],
      contact: attributes[:contact],
      last_login: attributes[:last_login],
      total_subscribers: attributes[:total_subscribers],
      links: Link.get_links_from_attributes(attributes)
    }
  end

  @doc false
  def get(override_url \\ "/") do
    case HTTPClient.get(override_url) do
      {:ok, %Response{status_code: 200, body: body}} ->
        {:ok, new(body)}

      {:ok, %Response{status_code: _, body: body}} ->
        {:error, body}

      {:error, error} ->
        {:error, error}
    end
  end

  @doc false
  def get!(override_url \\ "/") do
    {:ok, account} = get(override_url)
    account
  end

  @doc """
    Fetch a list of `Mailchimp.List` for the given account with an optional query params.
  """
  def lists(%__MODULE__{links: %{"lists" => %Link{href: href}}}, query_params \\ %{}) do
    {:ok, response} = HTTPClient.get(href, [], params: query_params)

    case response do
      %Response{status_code: 200, body: body} ->
        {:ok, Enum.map(body.lists, &List.new(&1))}

      %Response{status_code: _, body: body} ->
        {:error, body}
    end
  end

  @doc """
    Same as `lists/2`
    but raises errors.
  """
  def lists!(account, query_params \\ %{}) do
    {:ok, lists} = lists(account, query_params)
    lists
  end


  @doc """
    Fetch a `Mailchimp.List` from an ID
  """
  def get_list(%__MODULE__{links: %{"lists" => %Link{href: href}}}, list_id, query_params \\ %{}) do
    {:ok, response} = HTTPClient.get(href <> "/#{list_id}", [], params: query_params)

    case response do
      %Response{status_code: 200, body: body} ->
        {:ok, List.new(body)}

      %Response{status_code: _, body: body} ->
        {:error, body}
    end
  end

  @doc """
    Same as `get_list/3`
    but raises errors.
  """
  def get_list!(account, list_id, query_params \\ %{}) do
    {:ok, list} = get_list(account, list_id, query_params)
    list
  end
end
