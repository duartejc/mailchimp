use Mix.Config

config :mailchimp,
  api_key: "your apikey-us19"

import_config "#{Mix.env()}.exs"
