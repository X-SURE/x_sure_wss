defmodule XSureWss.Coinbase.WebsocketHandler do

  use Gdex.Websocket

  require Logger

  def handle_connect(gdax, state) do
    Logger.debug("Coinbase websocket Connected!")
    symbols = Enum.reduce(XSureWss.TickerUtils.get_crypto_symbols(), [], fn (symbol, acc) ->
      acc ++ ["#{symbol}-USD"]
    end)
    subscribe(gdax, :ticker_batch, symbols, authenticate: true)
    {:ok, state}
  end

  def handle_message(message, _gdax, state) do
    Logger.debug("Coinbase websocket Received message #{inspect message}")
    {:ok, state}
  end

  def handle_disconnect(_reason, _gdax, state) do
    Logger.debug("Coinbase websocket Disconnected!")
    {:ok, state}
  end

  def handle_info(message, _gdax, state) do
    IO.puts "INFO: #{inspect message}"
    Logger.debug("Coinbase INFO: #{inspect message}")
    {:ok, state}
  end
end
