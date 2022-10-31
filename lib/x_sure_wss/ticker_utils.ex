defmodule XSureWss.TickerUtils do
  require Logger


  @crypto_symbols [
    "BTC",
    "ETH",
    "BNB",
    "SOL",
    "ADA",
    "XRP",
    "DOT",
    "DOGE",
    "AVAX"
  ]

  def binance_trade_streams() do
    Enum.map(@crypto_symbols, fn s ->  "#{String.downcase(s)}usdt@trade" end)
  end

  def binance_ticker_streams() do
    Enum.map(@crypto_symbols, fn s ->  "#{String.downcase(s)}usdt@ticker" end)
  end

  def get_crypto_symbols() do
    @crypto_symbols
  end
end
