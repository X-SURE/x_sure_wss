defmodule XSureWss.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      XSureWss.Repo,
      # Start the Telemetry supervisor
      XSureWssWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: XSureWss.PubSub},
      # Start the Endpoint (http/https)
      XSureWssWeb.Endpoint,
      # Start a worker by calling: XSureWss.Worker.start_link(arg)
      # {XSureWss.Worker, arg}
      {ConCache, [
        name: :xsure_cache,
        ttl_check_interval: :timer.seconds(1),
        global_ttl: :timer.seconds(86400)]},
      XSureWss.Binance.Streamer,
      XSureWss.Coinbase.Streamer
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: XSureWss.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    XSureWssWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
