defmodule Faust.Repo do
  use Ecto.Repo,
    otp_app: :faust,
    adapter: Ecto.Adapters.Postgres

  use Scrivener, page_size: 2
end
