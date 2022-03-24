defmodule Mailchimp.Campaign.Tracking do
  @moduledoc """

  Tracking Options for Campaings

  ### Struct Fields

    * `opens` - Whether to [track opens](https://mailchimp.com/help/about-open-tracking/). Defaults to true. Cannot be set to false for variate campaigns.

    * `html_clicks` - Whether to [track clicks](https://mailchimp.com/help/enable-and-view-click-tracking/) in the HTML version of the campaign. Defaults to true. Cannot be set to false for variate campaigns.

    * `text_clicks` - Whether to [track clicks](https://mailchimp.com/help/enable-and-view-click-tracking/) in the plain-text version of the campaign. Defaults to true. Cannot be set to false for variate campaigns.

    * `goal_tracking` -Deprecated.

    * `ecomm360` - Whether to enable e-commerce tracking.

    * `google_analytics` - The custom slug for [Google Analytics](https://mailchimp.com/help/integrate-google-analytics-with-mailchimp/) tracking (max of 50 bytes).

    * `clicktale` - The custom slug for [ClickTale](https://mailchimp.com/pt-br/help/additional-tracking-options-for-campaigns/) tracking (max of 50 bytes)

    * `salesforce` - Deprecated.

  """

  defstruct [
    :opens,
    :html_clicks,
    :text_clicks,
    :goal_tracking,
    :ecomm360,
    :google_analytics,
    :clicktale,
    :salesforce
  ]

  @doc """
    Generates an `Mailchimp.Campaign.Tracking` struct from the given attributes.
  """
  def new(attributes) do
    %__MODULE__{
      opens: attributes[:opens],
      html_clicks: attributes[:html_clicks],
      text_clicks: attributes[:text_clicks],
      goal_tracking: attributes[:goal_tracking],
      ecomm360: attributes[:ecomm360],
      google_analytics: attributes[:google_analytics],
      clicktale: attributes[:clicktale],
      salesforce: attributes[:salesforce]
    }
  end
end
