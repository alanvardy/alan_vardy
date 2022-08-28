defmodule AlanVardy.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      AlanVardyWeb.Telemetry,
      {Phoenix.PubSub, name: AlanVardy.PubSub},
      AlanVardyWeb.Endpoint,
      ExRoboCop.start()
    ]

    opts = [strategy: :one_for_one, name: AlanVardy.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @impl true
  def config_change(changed, _new, removed) do
    AlanVardyWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
