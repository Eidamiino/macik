defmodule Macik.Repo do
  use Ecto.Repo,
    otp_app: :macik,
    adapter: Ecto.Adapters.Postgres
end
