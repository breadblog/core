use Mix.Config

config :core, Core.Repo,
  username: "postgres",
  password: "postgres",
  database: "core_test#{System.get_env("MIX_TEST_PARTITION")}",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :core, CoreWeb.Endpoint,
  http: [port: 4002],
  server: false

config :logger, level: :warn
