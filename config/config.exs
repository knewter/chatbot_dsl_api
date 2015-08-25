# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :chatbot_dsl_api, ChatbotDslApi.Endpoint,
  url: [host: "localhost"],
  root: Path.dirname(__DIR__),
  secret_key_base: "pOo2HryMfQXfrKHqOmcUUoU9rPO8zOpAOEaV4z/pQhUgmf2px6x3XVbnuuT2LKab",
  render_errors: [accepts: ~w(html json)],
  pubsub: [name: ChatbotDslApi.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :hedwig,
  clients: [
    %{
      jid: "user2@localhost",
      password: "mypass",
      nickname: "chatbot",
      resource: "lappitytoppity",
      config: %{ # This is only necessary if you need to override the defaults.
        server: "localhost",
        port: 5222
      },
      rooms: [
        "general@conference.localhost"
      ],
      handlers: [
        {ChatbotDSL.Handler, %{}}
      ]
    }
  ]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
