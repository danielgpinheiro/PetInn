defmodule PetInn.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      PetInnWeb.Telemetry,
      PetInn.Repo,
      {DNSCluster, query: Application.get_env(:pet_inn, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: PetInn.PubSub},
      # Start a worker by calling: PetInn.Worker.start_link(arg)
      # {PetInn.Worker, arg},
      # Start to serve requests, typically the last entry
      PetInnWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: PetInn.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    PetInnWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
