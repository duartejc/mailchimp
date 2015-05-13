defmodule Mailchimp.Mixfile do
  use Mix.Project

  def project do
    [app: :mailchimp,
     version: "0.0.1",
     elixir: "~> 1.0",
     deps: deps]
  end

  def application do
    [applications: [:logger, :httpoison]]
  end

  defp deps do
    [{:httpoison, "~> 0.6"},
     {:poison, "~> 1.4.0"}]
  end
end
