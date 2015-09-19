defmodule Mailchimp.Account do
  alias HTTPoison.Response
  alias Mailchimp.HTTPClient
  alias Mailchimp.Link
  alias Mailchimp.List

  defstruct account_id: nil, account_name: nil, contact: nil, last_login: nil, total_subscribers: 0, links: []

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

  def get do
    {:ok, response} = HTTPClient.get("/")
    case response do
      %Response{status_code: 200, body: body} ->
        {:ok, __MODULE__.new(body)}

      %Response{status_code: _, body: body} ->
        {:error, body}
    end
  end

  def lists(%__MODULE__{links: %{"lists" => %Link{href: href}}}) do
    {:ok, response} = HTTPClient.get(href)
    case response do
      %Response{status_code: 200, body: body} ->
        {:ok, Enum.map(body.lists, &List.new(&1))}

      %Response{status_code: _, body: body} ->
        {:error, body}
    end
  end
end
