defmodule XSureWss.Binance.Streamer do

  alias XSureWss.Binance.BinanceWss
  alias XSureWss.TickerUtils

  def child_spec(_args) do
    # Specs for the Binance websocket.
    streams = [Enum.join(TickerUtils.binance_trade_streams, "/"), Enum.join(TickerUtils.binance_ticker_streams, "/")]
    children =
      for {stream, i} <- Enum.with_index(streams) do
        Supervisor.child_spec({BinanceWss, stream},
         id: {BinanceWss, "stream_#{i}"}
        )
      end

    # Spec for the supervisor that will supervise the Binance websocket.
    %{
      id: BinanceStreamerSupervisor,
      type: :supervisor,
      start: {Supervisor, :start_link, [children, [strategy: :one_for_one]]}
    }
  end

end
