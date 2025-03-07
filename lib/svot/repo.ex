defmodule Svot.Repo do
  use Ecto.Repo,
    otp_app: :svot,
    adapter: Ecto.Adapters.Postgres
end
