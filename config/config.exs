# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.17.11",
  pet_inn: [
    args: ~w(js/app.ts --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

config :gettext, default_locale: "pt_BR"

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Configures the endpoint
config :pet_inn, PetInnWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [html: PetInnWeb.ErrorHTML, json: PetInnWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: PetInn.PubSub,
  live_view: [signing_salt: "er5pRhbb"]

config :pet_inn,
  ecto_repos: [PetInn.Repo],
  generators: [timestamp_type: :utc_datetime]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Configure tailwind (the version is required)
config :tailwind,
  version: "3.4.3",
  pet_inn: [
    args: ~w(
      --config=tailwind.config.js
      --input=css/app.css
      --output=../priv/static/assets/app.css
    ),

    # Import environment specific config. This must remain at the bottom
    # of this file so it overrides the configuration defined above.
    cd: Path.expand("../assets", __DIR__)
  ]

import_config "#{config_env()}.exs"

# Config Mailer
config :pet_inn, PetInn.Mailer.Adapter,
  adapter: Swoosh.Adapters.Brevo,
  api_key: System.get_env("BREVO_API_KEY")

config :swoosh, :api_client, Swoosh.ApiClient.Req
