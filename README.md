[![Hex Version](http://img.shields.io/hexpm/v/mailchimp.svg)](https://hex.pm/packages/mailchimp)

This is a basic Elixir wrapper for version 3 of the MailChimp API.

<div style="margin: 25px;">
<a href="https://rapidapi.com/package/MailChimp/functions?utm_source=MailchimpGitHub-Android&utm_medium=button&utm_content=Vendor_GitHub" style="
    all: initial;
    background-color: #498FE1;
    border-width: 0;
    border-radius: 5px;
    padding: 10px 20px;
    color: white;
    font-family: 'Helvetica';
    font-size: 12pt;
    background-image: url(https://scdn.rapidapi.com/logo-small.png);
    background-size: 25px;
    background-repeat: no-repeat;
    background-position-y: center;
    background-position-x: 10px;
    padding-left: 44px;
    cursor: pointer;">
  Run now on <b>RapidAPI</b>
</a>
</div>

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
