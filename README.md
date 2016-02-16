[![Hex Version](http://img.shields.io/hexpm/v/mailchimp.svg)](https://hex.pm/packages/mailchimp)

This is a basic Elixir wrapper for version 3 of the MailChimp API.

## Installation

First, add MailChimp lib to your `mix.exs` dependencies:

```elixir
def deps do
  [{:mailchimp, "~> 0.0.5"}]
end
```

and run `$ mix deps.get`. Now, list the `:mailchimp` application as your
application dependency:

```elixir
def application do
  [applications: [:mailchimp]]
end
```

## Usage

Put your API key in your *config.exs* file:

```elixir
config :mailchimp,
  apikey: "your api-us10"
```

Start a new process:  

    Mailchimp.start_link

### Getting Account Details

    Mailchimp.Account.get()

### Getting All Lists

    TODO

### Adding a Member to a List

    TODO
