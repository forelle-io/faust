defmodule Faust.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      # Start the Ecto repository
      Faust.Repo,
      # Запуск GenServer процесса, загружающего измененную структуру определенных таблиц в :ets
      Faust.HotTablesTablesGenServer,
      # Start the endpoint when the application starts
      FaustWeb.Endpoint,
      # Provides Presence tracking to processes and channels
      FaustWeb.Presence
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Faust.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    FaustWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
