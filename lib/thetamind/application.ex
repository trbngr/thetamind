defmodule Thetamind.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      Thetamind.Repo,
      ThetamindWeb.Telemetry,
      {Phoenix.PubSub, name: Thetamind.PubSub},
      ThetamindWeb.Endpoint,
      #
      #
      Thetamind.CommandedApp,
      Thetamind.ReadModel
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Thetamind.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ThetamindWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
