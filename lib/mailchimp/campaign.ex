defmodule Mailchimp.Campaign do
  alias HTTPoison.Response
  alias Mailchimp.HTTPClient
  alias Mailchimp.Link
  alias Mailchimp.Campaign.{Tracking, Content}

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
    :links,
  ]

  def new(attributes) do
    {:ok, create_time, _} = DateTime.from_iso8601(attributes[:create_time])
    send_time = if attributes[:send_time] do
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

  def list(query_params) do
    {:ok, response} = HTTPClient.get("/campaigns", [], params: query_params)
    case response do
      %Response{status_code: 200, body: body} ->
        {:ok, Enum.map(body.campaigns, &new(&1))}

      %Response{status_code: _, body: body} ->
        {:error, body}
    end
  end

  def list!(query_params \\ %{}) do
    {:ok, campaigns} = list(query_params)
    campaigns
  end

  def create(type, attrs \\ %{}) when type in [:regular, :plaintext, :absplit, :rss, :variate] do
    {:ok, response} = HTTPClient.post("/campaigns", Jason.encode!(Map.put(attrs, :type, type)))
    case response do
      %Response{status_code: 200, body: body} ->
        {:ok, new(body)}

      %Response{status_code: _, body: body} ->
        {:error, body}
    end
  end

  def create!(type, attrs \\ %{}) do
    {:ok, campaign} = create(type, attrs)
    campaign
  end

  def content(%__MODULE__{links: %{"content" => %Link{href: href}}}) do
    {:ok, response} = HTTPClient.get(href)
    case response do
      %Response{status_code: 200, body: body} ->
        {:ok, Content.new(body)}

      %Response{status_code: _, body: body} ->
        {:error, body}
    end
  end

  def content!(campaign) do
    {:ok, content} = content(campaign)
    content
  end
end
