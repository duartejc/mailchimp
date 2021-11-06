defmodule Mailchimp.Mixfile do
  use Mix.Project

  @source_url "https://github.com/duartejc/mailchimp"
  @version "0.1.2"

  def project do
    [
      app: :mailchimp,
      version: @version,
      elixir: "~> 1.7",
      package: package(),
      deps: deps(),
      docs: docs()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:httpoison, "~> 1.6"},
      {:jason, "~> 1.1"},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
      {:exvcr, "~> 0.11", only: :test}
    ]
  end

  defp package do
    [
      description: "A basic Elixir wrapper for version 3 of the MailChimp API.",
      files: ["lib", "mix.exs", "README.md", "LICENSE.md"],
      maintainers: ["Jean Duarte", "Eric Froese"],
      licenses: ["MIT"],
      links: %{"GitHub" => @source_url}
    ]
  end

  defp docs do
    [
      extras: [
        "LICENSE.md": [title: "License"],
        "README.md": [title: "Overview"]
      ],
      main: "readme",
      source_url: @source_url,
      formatters: ["html"]
    ]
  end
end
