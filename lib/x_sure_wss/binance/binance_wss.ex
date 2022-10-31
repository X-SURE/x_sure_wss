defmodule XSureWss.Binance.BinanceWss do
  use WebSockex

  require Logger

  @stream_endpoint "wss://stream.binance.com:9443/stream?streams="

  def start_link(streams) do
    case WebSockex.start_link(
      "#{@stream_endpoint}#{streams}",
      __MODULE__,
      nil
    ) do
      {:ok, pid} ->
        Logger.info("Binance websocket started for #{streams}")
        {:ok, pid}
      {:error, reason} ->
        Logger.error("error: #{inspect(reason)}")
        {:error, %{msg: "#{inspect(reason)}"}}
    end

  end

  def terminate(reason, state) do
    Logger.warning("\nSocket Terminating:\n#{inspect reason}\n\n#{inspect state}\n")
    exit(:normal)
  end

  def handle_frame({_type, msg}, state) do
    case Jason.decode(msg) do
      {:ok, event} -> process_event(event)
      {:error, _} -> Logger.error("Unable to parse msg: #{msg}")
    end

    {:ok, state}
  end

  defp process_event(%{"data" => event, "stream"=> stream}) do
    case event do
      %{"e" => "trade"} ->
        Logger.debug("Stream tread event received  #{stream} #{inspect(event)}")
        ConCache.put(:xsure_cache, stream, event["p"])
      %{"e" => "24hrTicker"} ->
        Logger.debug("Stream ticker event received  #{stream} #{inspect(event)}")
        ConCache.put(:xsure_cache, stream, event["0"])
      _->
        Logger.debug("other steam event")
    end

  end
end
