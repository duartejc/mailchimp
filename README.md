This is a basic Elixir wrapper for version 3 of the MailChimp API.

## Usage

1. Put your API key in your *config.exs* file.

2. Start a new process:


    Mailchimp.start_link []

### Getting Account Details

    Mailchimp.get_account_details/0

### Getting All Lists

    Mailchimp.get_all_lists/0
