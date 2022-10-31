defmodule XSureWss.Coinbase.CoinbaseWss do

  alias XSureWss.Coinbase.WebsocketHandler

  def start_link(state) do
    Gdex.Websocket.start_link(WebsocketHandler, state)
  end

  def child_spec(opts) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [opts]},
      type: :worker,
      restart: :permanent,
      shutdown: 500
    }
  end
end
