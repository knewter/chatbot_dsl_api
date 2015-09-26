use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :chatbot_dsl_api, ChatbotDslApi.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :chatbot_dsl_api, ChatbotDslApi.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: System.get_env("DATABASE_POSTGRESQL_USERNAME") || "postgres",
  password: System.get_env("DATABASE_POSTGRESQL_PASSWORD") || "postgres",
  database: "chatbot_dsl_api_test",
  pool: Ecto.Adapters.SQL.Sandbox
