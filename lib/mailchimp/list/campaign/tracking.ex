defmodule Mailchimp.Campaign.Tracking do

  defstruct [
    :opens,
    :html_clicks,
    :text_clicks,
    :goal_tracking,
    :ecomm360,
    :google_analytics,
    :clicktale,
    :salesforce,
  ]

  def new(attributes) do
    %__MODULE__{
      opens: attributes[:opens],
      html_clicks: attributes[:html_clicks],
      text_clicks: attributes[:text_clicks],
      goal_tracking: attributes[:goal_tracking],
      ecomm360: attributes[:ecomm360],
      google_analytics: attributes[:google_analytics],
      clicktale: attributes[:clicktale],
      salesforce: attributes[:salesforce],
    }
  end
end
