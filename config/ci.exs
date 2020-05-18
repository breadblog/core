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

database_port = System.get_env("POSTGRES_PORT") ||
  raise """
  missing POSTGRES_PORT
  """

database_name = "core_test#{System.get_env("MIX_TEST_PARTITION")}"

IO.puts "connecting to #{database_host}://#{database_user}:#{database_password}:#{database_port}/#{database_name}"

config :core, Core.Repo,
  hostname: "localhost",
  user: "postgres",
  password: "postgres",
  database: "postgres",
  port: 5432,
  pool: Ecto.Adapters.SQL.Sandbox

config :core, CoreWeb.Endpoint,
  http: [port: 4002],
  server: false

config :logger, level: :warn
