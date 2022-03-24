defmodule Mailchimp.Campaign.Content do
  alias Mailchimp.Link
  alias HTTPoison.Response
  alias Mailchimp.HTTPClient

  @moduledoc """

  The HTML content for your Mailchimp landing pages.

  ### Struct Fields

    * `variate_contents` - The Mailchimp account ID.

    * `plain_text` - The plain-text portion of the campaign. If left unspecified, we'll generate this automatically.

    * `html` - The raw HTML for the campaign.

    * `archive_html` - The Archive HTML for the campaign.

    * `links` - A list of `Mailchimp.Link` types and descriptions for the API schema documents.
  """

  defstruct [
    :variate_contents,
    :plain_text,
    :html,
    :archive_html,
    :links
  ]

  @doc """
    Generates an `Mailchimp.Campaing.Content` struct from the given attributes.
  """
  def new(attributes) do
    %__MODULE__{
      variate_contents: attributes[:variate_contents],
      plain_text: attributes[:plain_text],
      html: attributes[:html],
      archive_html: attributes[:archive_html],
      links: Link.get_links_from_attributes(attributes)
    }
  end

  @doc """
    Updates a Content in Mailchimp
  """
  def update(%__MODULE__{links: %{"self" => %Link{href: href}}}, attrs \\ %{}) do
    {:ok, response} = HTTPClient.put(href, Jason.encode!(attrs))

    case response do
      %Response{status_code: 200, body: body} ->
        {:ok, new(body)}

      %Response{status_code: _, body: body} ->
        {:error, body}
    end
  end

  @doc """
    Same as `update/2`
    but raises errors.
  """
  def update!(content, attrs \\ %{}) do
    {:ok, content} = update(content, attrs)
    content
  end
end
