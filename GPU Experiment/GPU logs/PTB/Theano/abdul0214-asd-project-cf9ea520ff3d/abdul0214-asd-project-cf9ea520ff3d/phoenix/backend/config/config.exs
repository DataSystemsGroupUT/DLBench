# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :backend,
  ecto_repos: [Backend.Repo]

# Configures the endpoint
config :backend, BackendWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "waz9oG3wvVPepOtUUNJzIQXRzi3TqndNa2HTDS+gT2FwKVLtaw7nazeiMqCiV1co",
  render_errors: [view: BackendWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Backend.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

config :backend, BackendWeb.Auth.Guardian,
       issuer: "backend",
       secret_key: "SECRET"

config :backend, BackendWeb.Auth.Guardian,
       issuer: "backend",
       secret_key: "SECRET"
