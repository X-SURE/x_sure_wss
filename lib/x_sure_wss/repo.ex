defmodule XSureWss.Repo do
  use Ecto.Repo,
    otp_app: :x_sure_wss,
    adapter: Ecto.Adapters.Postgres
end
