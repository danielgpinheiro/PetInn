import Config

# Configure your database
#

# Print only warnings and errors during test
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :logger, level: :warning

config :pet_inn, PetInn.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "pet_inn_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  # We don't run a server during test. If one is required,
  # you can enable the server option below.
  pool_size: System.schedulers_online() * 2

config :pet_inn, PetInnWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "3HizC1chyQC+u82fA/sVzsCqsUsWvwp6xc3/XD/BRPMy9+Z2UQvZXmhXVkryUCpj",
  server: false

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

# Enable helpful, but potentially expensive runtime checks
config :phoenix_live_view,
  enable_expensive_runtime_checks: true
