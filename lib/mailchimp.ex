defmodule Mailchimp do
  use Application
  use GenServer
  require Logger

  @apikey Application.get_env :mailchimp, :apikey

  ### Public API
  def start_link do
    shard = get_shard
    apiroot = "https://#{shard}.api.mailchimp.com/3.0/"
    config = %{apiroot: apiroot, apikey: @apikey}
    GenServer.start_link(Mailchimp, config, name: :mailchimp)
  end

  def get_account_details do
    GenServer.call(:mailchimp, :account_details)
  end

  def get_all_lists do
    GenServer.call(:mailchimp, :all_lists)
  end

  def get_list_members(list_id) do
    GenServer.call(:mailchimp, {:list_members, list_id})
  end

  def add_member(list_id, email) do
    GenServer.call(:mailchimp, {:add_member, list_id, email})
  end

  def add_pending_member(list_id, email) do
    GenServer.call(:mailchimp, {:add_pending_member, list_id, email})
  end

  def get_member(list_id, email) do
    GenServer.call(:mailchimp, {:get_member, list_id, email})
  end

  def remove_member(list_id, email) do
    GenServer.call(:mailchimp, {:remove_member, list_id, email})
  end

  ### Server API
  def handle_call(:account_details, _from, config) do
    details = Mailchimp.Account.get_details(config)
    {:reply, details, config}
  end

  def handle_call(:all_lists, _from, config) do
    lists = Mailchimp.List.all(config)
    {:reply, lists, config}
  end

  def handle_call({:list_members, list_id}, _from, config) do
    members = Mailchimp.List.members(config, list_id)
    {:reply, members, config}
  end

  def handle_call({:add_member, list_id, email}, _from, config) do
    member = Mailchimp.List.add_member(config, %{"list_id" => list_id, "email" => email})
    {:reply, member, config}
  end

  def handle_call({:add_pending_member, list_id, email}, _from, config) do
    member = Mailchimp.List.add_pending_member(config, %{"list_id" => list_id, "email" => email})
    {:reply, member, config}
  end

  def handle_call({:get_member, list_id, email}, _from, config) do
    member = Mailchimp.List.get_member(config, %{"list_id" => list_id, "email" => email})
    {:reply, member, config}
  end

  def handle_call({:remove_member, list_id, email}, _from, config) do
    member = Mailchimp.List.remove_member(config, %{"list_id" => list_id, "email" => email})
    {:reply, member, config}
  end

  def get_shard do
    parts = @apikey
    |> String.split(~r{-})

    case length(parts) do
      2 ->
        List.last parts
      _ ->
        Logger.error "This doesn't look like an API Key: #{@apikey}"
        Logger.info "The API Key should have both a key and a server name, separated by a dash, like this: abcdefg8abcdefg6abcdefg4-us1"
        {:error}
    end
  end

end
