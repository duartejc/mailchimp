defmodule Mailchimp.Mixfile do
  use Mix.Project

  def project do
    [app: :mailchimp,
     version: "0.0.6",
     elixir: "~> 1.4",
     aliases: aliases(),
     description: description(),
     package: package(),
     elixirc_paths: elixirc_paths(Mix.env),
     source_url: "https://github.com/duartejc/mailchimp",
     deps: deps(),
     docs: [readme: "README.md", main: "README"]]
  end

  def application do
    [
      extra_applications: [:logger],
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_),     do: ["lib"]

  defp aliases do
    [
      test: ["mailchimp.flush_dumps", "test"],
    ]
  end

  defp description do
    """
    A basic Elixir wrapper for version 3 of the MailChimp API.
    """
  end

  defp deps do
    [{:httpoison, "~> 0.12"},
     {:poison, "~> 3.1"},
     {:mock, "~> 0.2.0", only: :test}]
  end

  defp package do
    [files: ["lib", "mix.exs", "README.md", "LICENSE"],
     maintainers: ["Jean Duarte"],
     licenses: ["MIT"],
     links: %{"GitHub" => "https://github.com/duartejc/mailchimp"}]
  end
end
