use Mix.Config

database_host = System.get_env("POSTGRES_HOST") ||
  raise """
  missing POSTGRES_HOST
  """

database_user = System.get_env("POSTGRES_USER") ||
  raise """
  missing POSTGRES_USER
  """

database_password = System.get_env("POSTGRES_PASSWORD") ||
  raise """
  missing POSTGRES_PASSWORD
  """

config :core, Core.Repo,
  hostname: database_host,
  user: database_user,
  password: database_password,
  database: "core_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox

config :core, CoreWeb.Endpoint,
  http: [port: 4002],
  server: false

config :logger, level: :warn
