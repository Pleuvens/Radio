import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :radio, Radio.Repo,
  username: "postgres",
  password: System.get_env("POSTGRES_PASSWORD"),
  hostname: System.get_env("POSTGRES_HOST"),
  database: "radio_test",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# Configure AWS S3
config :ex_aws,
  json_codec: Jason,
  access_key_id: System.get_env("AWS_ACCESS_KEY_ID"),
  secret_access_key: System.get_env("AWS_SECRET_ACCESS_KEY")

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :radio, RadioWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "FlcGbcZmI5YweJX9BXaBoL8bPdPHS++RTmWBs8axGDrpw8NBs9zGq+RGQYWB/qzG",
  server: false

# In test we don't send emails.
config :radio, Radio.Mailer, adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters.
config :swoosh, :api_client, false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
