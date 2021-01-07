[![Hex Version](http://img.shields.io/hexpm/v/mailchimp.svg)](https://hex.pm/packages/mailchimp)

This is a basic Elixir wrapper for version 3 of the MailChimp API.

## Installation

First, add MailChimp lib to your `mix.exs` dependencies:

```elixir
def deps do
  [{:mailchimp, "~> 0.1.2"}]
end
```

and run `$ mix deps.get`

## Usage

Put your API key in your `config.exs` file:

```elixir
config :mailchimp,
  api_key: "your api-us10"
```

or

```elixir
  Application.put_env(:mailchimp, :api_key, "your apikey-us12")
```

### Getting Account Details

    Mailchimp.Account.get!()

### Getting All Lists

    Mailchimp.Account.get! |> Mailchimp.Account.lists!

### Adding a Member to a List

    Mailchimp.List.create_member(list, "test@email.com", "subscribed", %{}, %{})

### Creating a new Campaign

    Mailchimp.Campaign.create!(:regular)
