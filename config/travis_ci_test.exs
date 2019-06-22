use Mix.Config

# Print only warnings and errors during test
config :logger, level: :warn

# Configure database
config :faust, Faust.Repo,
  username: "postgres",
  password: "postgres",
  database: "travis_ci_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
