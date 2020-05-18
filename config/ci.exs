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

database_name = "core_test#{System.get_env("MIX_TEST_PARTITION")}"

IO.puts "connecting to #{database_host}://#{database_user}:#{database_password}:5432/#{database_name}"

config :core, Core.Repo,
  hostname: database_host,
  user: database_user,
  password: database_password,
  database: database_name,
  pool: Ecto.Adapters.SQL.Sandbox

config :core, CoreWeb.Endpoint,
  http: [port: 4002],
  server: false

config :logger, level: :warn
