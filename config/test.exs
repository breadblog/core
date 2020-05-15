use Mix.Config

# Configure your database
config :blog_core, BlogCore.Repo,
  username: "postgres",
  password: "postgres",
  database: "blog_core_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :blog_core, BlogCoreWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Override
import_config "test.secret.exs"
