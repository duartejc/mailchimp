# MailChimp

[![Module Version](https://img.shields.io/hexpm/v/mailchimp.svg)](https://hex.pm/packages/mailchimp)
[![Hex Docs](https://img.shields.io/badge/hex-docs-lightgreen.svg)](https://hexdocs.pm/mailchimp/)
[![Total Download](https://img.shields.io/hexpm/dt/mailchimp.svg)](https://hex.pm/packages/mailchimp)
[![License](https://img.shields.io/hexpm/l/mailchimp.svg)](https://github.com/duartejc/mailchimp/blob/master/LICENSE.md)
[![Last Updated](https://img.shields.io/github/last-commit/duartejc/mailchimp.svg)](https://github.com/duartejc/mailchimp/commits/master)

This is a basic Elixir wrapper for version 3 of the MailChimp API.

## Installation

First, add MailChimp lib to your `mix.exs` dependencies:

```elixir
def deps do
  [
    {:mailchimp, "~> 0.1.2"}
  ]
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

```elixir
Mailchimp.Account.get!()
```

### Getting All Lists

```elixir
Mailchimp.Account.get! |> Mailchimp.Account.lists!
```

### Adding a Member to a List

```elixir
Mailchimp.List.create_member(list, "test@email.com", "subscribed", %{}, %{})
```

### Creating a new Campaign

```elixir
Mailchimp.Campaign.create!(:regular)
```

## Copyright and License

Copyright (c) 2017 Jean Duarte

This work is free. You can redistribute it and/or modify it under the
terms of the MIT License. See the [LICENSE.md](./LICENSE.md) file for more details.
