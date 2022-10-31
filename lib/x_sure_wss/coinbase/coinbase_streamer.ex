defmodule XSureWss.Coinbase.Streamer do

  alias XSureWss.Coinbase.CoinbaseWss

  def child_spec(_args) do
    # Specs for the Coinbase websocket.
    children =
      [Supervisor.child_spec({CoinbaseWss, ""},
        id: {CoinbaseWss, "coinbase_stream_"}
      )]

    # Spec for the supervisor that will supervise the Binance websocket.
    %{
      id: CoinbaseStreamerSupervisor,
      type: :supervisor,
      start: {Supervisor, :start_link, [children, [strategy: :one_for_one]]}
    }
  end

end
