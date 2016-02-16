defmodule Mailchimp.Mixfile do
  use Mix.Project

  def project do
    [app: :mailchimp,
     version: "0.0.4",
     elixir: "~> 1.0",
     description: description,
     package: package,
     source_url: "https://github.com/duartejc/mailchimp",
     deps: deps,
     docs: [readme: "README.md", main: "README"]]
  end

  def application do
    [mod: {Mailchimp, []},
      applications: [:logger, :httpoison]]
  end

  defp description do
    """
    A basic Elixir wrapper for version 3 of the MailChimp API.
    """
  end

  defp deps do
    [{:httpoison, "~> 0.7.3"},
     {:poison, "~> 2.1.0"}]
  end

  defp package do
    [files: ["lib", "mix.exs", "README.md", "LICENSE"],
     maintainers: ["Jean Duarte"],
     licenses: ["MIT"],
     links: %{"GitHub" => "https://github.com/duartejc/mailchimp"}]
  end
end
