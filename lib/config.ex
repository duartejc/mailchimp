defmodule Mailchimp.Config do
  use GenServer

  defstruct api_key: nil, api_version: "3.0"

  require Logger

  # Public API

  def start_link(%__MODULE__{}=config) do
    Agent.start_link(fn -> config end, name: __MODULE__)
  end

  def start_link do
    config = %__MODULE__{
      api_key: get_api_key_from_config,
      api_version: get_api_version_from_config
    }

    Agent.start_link(fn -> config end, name: __MODULE__)
  end

  def root_endpoint do
    Agent.get(__MODULE__, fn %{api_key: api_key, api_version: api_version} ->
      {:ok, shard} = get_shard(api_key)
      "https://#{shard}.api.mailchimp.com/#{api_version}/"
    end)
  end

  def api_key do
    Agent.get(__MODULE__, fn %{api_key: api_key} -> api_key end)
  end

  def api_version do
    Agent.get(__MODULE__, fn %{api_version: api_version} -> api_version end)
  end

  def update(config) when is_list(config) do
    Agent.update(__MODULE__, fn current_config ->
      Enum.reduce(config, current_config, fn({k,v}, acc) -> Map.put(acc, k, v) end)
    end)
  end

  # Private methods

  defp sanitize_api_key({:system, env_var}) do
    sanitize_api_key System.get_env(env_var)
  end

  defp sanitize_api_key(api_key) do
    api_key
  end

  defp get_api_key_from_config do
    sanitize_api_key(Application.get_env(:mailchimp, :apikey)) || sanitize_api_key(Application.get_env(:mailchimp, :api_key))
  end

  defp get_api_version_from_config do
    Application.get_env(:mailchimp, :api_version) || "3.0"
  end

  defp get_shard(api_key) do
    shard = api_key
            |> String.split(~r{-})
            |> List.last

    case shard do
      nil ->
        Logger.error "[mailchimp] This doesn't look like an API Key: #{api_key}"
        Logger.error "[mailchimp] The API Key should have both a key and a server name, separated by a dash, like this: abcdefg8abcdefg6abcdefg4-us1"
        :error

      _ ->
        {:ok, shard}
    end
  end
end
