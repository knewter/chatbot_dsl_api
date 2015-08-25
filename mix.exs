defmodule ChatbotDslApi.Mixfile do
  use Mix.Project

  def project do
    [app: :chatbot_dsl_api,
     version: "0.0.1",
     elixir: "~> 1.0",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [mod: {ChatbotDslApi, []},
     applications: [:phoenix, :phoenix_html, :cowboy, :logger,
                    :phoenix_ecto, :postgrex, :httpoison, :chatbot_dsl_playground]]
  end

  # Specifies which paths to compile per environment
  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_),     do: ["lib", "web"]

  # Specifies your project dependencies
  #
  # Type `mix help deps` for examples and options
  defp deps do
    [{:phoenix, "~> 0.16"},
     {:phoenix_ecto, "~> 1.1"},
     {:postgrex, ">= 0.0.0"},
     {:phoenix_html, "~> 2.1"},
     {:phoenix_live_reload, "~> 0.6", only: :dev},
     {:cowboy, "~> 1.0"},
     {:chatbot_dsl_playground, github: "knewter/chatbot_dsl_playground"},
     #{:chatbot_dsl_playground, path: "/home/jadams/projects/chatbot_dsl/chatbot_dsl_playground"},
     {:ex_unit_api_documentation, github: "dantswain/ex_unit_api_documentation"},
     {:cors_plug, "~> 0.1.3"},
   ]
  end
end
