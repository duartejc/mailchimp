defmodule Mailchimp.Account do
  import Mailchimp.HTTPClient

  def get_details(config) do
    map_header = %{"Authorization" => "apikey #{config.apikey}"}
    url = config.apiroot
    get(url, map_header)
  end

end
