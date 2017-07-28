use Mix.Config

if Mix.env == :test do
  config :mailchimp,
    apikey: "your apikey-us12"
end
