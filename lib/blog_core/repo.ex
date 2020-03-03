defmodule BlogCore.Repo do
  use Ecto.Repo,
    otp_app: :blog_core,
    adapter: Ecto.Adapters.Postgres
end
