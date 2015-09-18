defmodule Mailchimp do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(Mailchimp.Config, []),
    ]

    opts = [strategy: :one_for_one, name: Aliver.Supervisor]
    Supervisor.start_link(children, opts)
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
end
