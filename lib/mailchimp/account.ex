defmodule Mailchimp.Account do
  alias HTTPoison.Response
  alias Mailchimp.HTTPClient
  alias Mailchimp.Link
  alias Mailchimp.List

  defstruct account_id: nil,
            account_name: nil,
            contact: nil,
            last_login: nil,
            total_subscribers: 0,
            links: []

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

  def get(override_url \\ "/") do
    case HTTPClient.get(override_url) do
      {:ok, %Response{status_code: 200, body: body}} ->
        {:ok, __MODULE__.new(body)}

      {:ok, %Response{status_code: _, body: body}} ->
        {:error, body}

      {:error, error} ->
        {:error, error}
    end
  end

  def get!(override_url \\ "/") do
    {:ok, account} = get(override_url)
    account
  end

  def lists(%__MODULE__{links: %{"lists" => %Link{href: href}}}, query_params \\ %{}) do
    {:ok, response} = HTTPClient.get(href, [], params: query_params)

    case response do
      %Response{status_code: 200, body: body} ->
        {:ok, Enum.map(body.lists, &List.new(&1))}

      %Response{status_code: _, body: body} ->
        {:error, body}
    end
  end

  def lists!(account, query_params \\ %{}) do
    {:ok, lists} = lists(account, query_params)
    lists
  end

  @doc """
    Fetch a List from an ID
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

  def get_list!(account, list_id, query_params \\ %{}) do
    {:ok, list} = get_list(account, list_id, query_params)
    list
  end
end
