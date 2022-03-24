defmodule Mailchimp.Campaign do
  alias HTTPoison.Response
  alias Mailchimp.HTTPClient
  alias Mailchimp.Link
  alias Mailchimp.Campaign.{Tracking, Content}
  @moduledoc """

  Campaigns are how you send emails to your Mailchimp list.
  Use the Campaigns API calls to manage campaigns in your Mailchimp account.

  ### Struct Fields

    * `id` - A string that uniquely identifies this campaign.

    * `web_id` - The ID used in the Mailchimp web application. View this campaign in your Mailchimp account at https://{dc}.admin.mailchimp.com/campaigns/show/?id={web_id}.

    * `type` - There are four types of [campaigns](https://mailchimp.com/help/getting-started-with-campaigns/) you can create in Mailchimp. A/B Split campaigns have been deprecated and variate campaigns should be used instead. Possible values: "regular", "plaintext", "absplit", "rss", or "variate".

    * `create_time` - The date and time the campaign was created in ISO 8601 format.

    * `archive_url` - The link to the campaign's archive version in ISO 8601 format.

    * `long_archive_url` - The original link to the campaign's archive version.

    * `status` - The current status of the campaign. Possible values: "save", "paused", "schedule", "sending", "sent", "canceled", "canceling", or "archived".

    * `emails_sent` - The total number of emails sent for this campaign.

    * `send_time` - The date and time a campaign was sent.

    * `content_type` - How the campaign's content is put together. Possible values: "template", "html", "url", or "multichannel".

    * `recipients` - List settings for the campaign.

    * `settings` - The settings for your campaign, including subject, from name, reply-to address, and more.

    * `variate_settings` - The settings specific to A/B test campaigns.

    * `tracking` - The tracking options for a campaign.

    * `rss_opts` - [RSS options](https://mailchimp.com/help/share-your-blog-posts-with-mailchimp/) for a campaign.

    * `ab_split_opts` - [A/B Testing options](https://mailchimp.com/help/about-ab-testing-campaigns/) for a campaign.

    * `social_card` - The preview for the campaign, rendered by social networks like Facebook and Twitter. [Learn more](https://mailchimp.com/help/enable-and-customize-social-cards/).

    * `report_summary` - For sent campaigns, a summary of opens, clicks, and e-commerce data.

    * `delivery_status` - Updates on campaigns in the process of sending.

  """

  defstruct [
    :id,
    :web_id,
    :type,
    :create_time,
    :archive_url,
    :long_archive_url,
    :status,
    :emails_sent,
    :send_time,
    :content_type,
    :recipients,
    :settings,
    :variate_settings,
    :tracking,
    :rss_opts,
    :ab_split_opts,
    :social_card,
    :report_summary,
    :delivery_status,
    :links
  ]

  @doc """
    Generates an `Mailchimp.Campaign` struct from the given attributes.
  """
  def new(attributes) do
    {:ok, create_time, _} = DateTime.from_iso8601(attributes[:create_time])

    send_time =
      if attributes[:send_time] do
        DateTime.from_iso8601(attributes[:send_time])
      end

    %__MODULE__{
      id: attributes[:id],
      web_id: attributes[:web_id],
      type: String.to_atom(attributes[:type]),
      create_time: create_time,
      archive_url: attributes[:archive_url],
      long_archive_url: attributes[:long_archive_url],
      status: attributes[:status],
      emails_sent: attributes[:emails_sent],
      send_time: send_time,
      content_type: attributes[:content_type],
      recipients: attributes[:recipients],
      settings: attributes[:settings],
      variate_settings: attributes[:variate_settings],
      tracking: Tracking.new(attributes[:tracking]),
      rss_opts: attributes[:rss_opts],
      ab_split_opts: attributes[:ab_split_opts],
      social_card: attributes[:social_card],
      report_summary: attributes[:report_summary],
      delivery_status: attributes[:delivery_status],
      links: Link.get_links_from_attributes(attributes)
    }
  end

  @doc """
    Creates an empty list
  """
  def list(), do: list([])

  @doc """
    Fetch campaigns with query params
  """
  def list(query_params) do
    {:ok, response} = HTTPClient.get("/campaigns", [], params: query_params)

    case response do
      %Response{status_code: 200, body: body} ->
        {:ok, Enum.map(body.campaigns, &new(&1))}

      %Response{status_code: _, body: body} ->
        {:error, body}
    end
  end

  @doc """
    Same as `list/1`
    but raises errors.
  """
  def list!(query_params \\ %{}) do
    {:ok, campaigns} = list(query_params)
    campaigns
  end

  @doc """
    Creates a `Mailchimp.Campaign` with additional fields for attributes and sends it to mailchimp
  """
  def create(type, attrs \\ %{}) when type in [:regular, :plaintext, :absplit, :rss, :variate] do
    {:ok, response} = HTTPClient.post("/campaigns", Jason.encode!(Map.put(attrs, :type, type)))

    case response do
      %Response{status_code: 200, body: body} ->
        {:ok, new(body)}

      %Response{status_code: _, body: body} ->
        {:error, body}
    end
  end

  @doc """
    Same as `create/2`
    but raises errors.
  """
  def create!(type, attrs \\ %{}) when type in [:regular, :plaintext, :absplit, :rss, :variate] do
    {:ok, campaign} = create(type, attrs)
    campaign
  end

  @doc """
    Fetches the `Mailchimp.Campaign.Content` for a given campaing
  """

  def content(%__MODULE__{links: %{"content" => %Link{href: href}}}) do
    {:ok, response} = HTTPClient.get(href)

    case response do
      %Response{status_code: 200, body: body} ->
        {:ok, Content.new(body)}

      %Response{status_code: _, body: body} ->
        {:error, body}
    end
  end

  @doc """
    Same as `content/1`
    but raises errors.
  """
  def content!(campaign) do
    {:ok, content} = content(campaign)
    content
  end
end
