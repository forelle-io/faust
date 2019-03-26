use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :faust, FaustWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :faust, Faust.Repo,
  username: "faust",
  password: "faust",
  database: "faust_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
