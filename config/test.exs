use Mix.Config

config :mailchimp,
  api_key: System.get_env("MAILCHIMP_TEST_API_KEY", "your apikey-us19")
