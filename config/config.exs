# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :toast,
  ecto_repos: [Toast.Repo]

# Configures the endpoint
config :toast, ToastWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "SO/d1I7f276l1BPp/z4fkL7pYZ0g8rcMV62EPzroRc20ipgjGWEN+LRrh1RWbrkp",
  render_errors: [view: ToastWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Toast.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.

config :phx_izitoast, :opts,
  # bottomRight, bottomLeft, topRight, topLeft, topCenter, 
  position: "topLeft",
  # dark,
  theme: "light",
  timeout: 5000,
  close: true,
  titleSize: 24,
  messageSize: 23,
  progressBar: true

import_config "#{Mix.env()}.exs"
