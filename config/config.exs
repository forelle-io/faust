# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :faust,
  ecto_repos: [Faust.Repo]

# Configures the endpoint
config :faust, FaustWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "TySzoftkwbMfzcIYzz8LucWCK6xI1015SBCeAuMXs1sTnN7QU7gUqbctEi/uvR84",
  render_errors: [view: FaustWeb.ErrorView, accepts: ~w(html json)],
  live_view: [
    signing_salt: "7HekGYwxATz33gM/rH9q2mV+uKJq5/Hu"
  ],
  pubsub: [name: Faust.PubSub, adapter: Phoenix.PubSub.PG2]

config :phoenix,
  template_engines: [leex: Phoenix.LiveView.Engine]

config :faust, Faust.Guardian,
  issuer: "faust",
  secret_key: "K1C9WbLyaYrG2EIwx1nkAzEaberOndYsc8sF+skoMXedXdZ5lMWHQL+3pLoM7m3J"

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Creating letter avatar from user's name
config :alchemic_avatar,
  cache_base_path: "#{System.user_home()}/media",
  colors_palette: :iwanthue,
  weight: 500,
  annotate_position: "-0+10",
  app_name: :faust

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
