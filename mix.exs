defmodule Mailchimp.Mixfile do
  use Mix.Project

  def project do
    [
      app: :mailchimp,
      version: "0.1.0",
      elixir: "~> 1.7",
      description: description(),
      package: package(),
      source_url: "https://github.com/duartejc/mailchimp",
      deps: deps(),
      docs: [readme: "README.md", main: "README"]
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp description do
    """
    A basic Elixir wrapper for version 3 of the MailChimp API.
    """
  end

  defp deps do
    [
      {:httpoison, "~> 1.6"},
      {:jason, "~> 1.1"},
      {:ex_doc, "~> 0.21", only: :dev, runtime: false},
      {:exvcr, "~> 0.11", only: :test}
    ]
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README.md", "LICENSE"],
      maintainers: ["Jean Duarte"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/duartejc/mailchimp"}
    ]
  end
end
