defmodule ChatbotDslApi.Router do
  use ChatbotDslApi.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ChatbotDslApi do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  scope "/api", ChatbotDslApi do
    pipe_through :api
    resources "/chatbots", ChatbotController do
      resources "/rules", RuleController
    end
  end
end
