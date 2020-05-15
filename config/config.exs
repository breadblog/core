# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :blog_core,
  ecto_repos: [BlogCore.Repo],
  generators: [binary_id: true]

# Configures the endpoint
config :blog_core, BlogCoreWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "H9tdjv8gf6mRERdd7umK4/Cs1gcJD7mQgqklQR6mpeDecamZ9bgbrLa28ryh+qdS",
  render_errors: [view: BlogCoreWeb.ErrorView, accepts: ~w(json)],
  pubsub_server: BlogCore.PubSub,
  live_view: [signing_salt: "we6vP8CROV8h8okR/K8nnl0ocCn4XmeD"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
