# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :peedy_web, PeedyWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "VlSo6myOvQ/GWBGBEDe6oJ/X8Z8I3Yw/F37NdVBSvZgMfXg529KbpNaM8L2gujqD",
  render_errors: [view: PeedyWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: PeedyWeb.PubSub,
           adapter: Phoenix.PubSub.PG2]

config :peedy_web, ecto_repos: []

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
