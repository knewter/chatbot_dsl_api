defmodule ChatbotDslApi do
  use Application
  alias ChatbotDslApi.Repo
  alias ChatbotDslApi.Chatbot
  alias ChatbotDslApi.Rule

  @json_tableflip_ast """
  {
    "type": "if",
    "arguments": [
      {
        "type": "contains",
        "arguments": [
          {"type": "var", "arguments": [{"type": "atom", "arguments": ["input"]}]},
          {"type": "string", "arguments": [":tableflip:"]}
        ]
      },
      {"type": "response", "arguments": ["(╯°□°）╯︵ ┻━┻"]}
    ]
  }
  """

  @macabre_ast """
  {
    "type": "if",
    "arguments": [
      {
        "type": "contains",
        "arguments": [
          {"type": "var", "arguments": [{"type": "atom", "arguments": ["input"]}]},
          {"type": "string", "arguments": ["brb"]}
        ]
      },
      {"type": "response", "arguments": ["unless you die, amirite?"]}
    ]
  }
  """

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      # Start the endpoint when the application starts
      supervisor(ChatbotDslApi.Endpoint, []),
      # Start the Ecto repository
      worker(Repo, []),
      # Here you could define other workers and supervisors as children
      # worker(ChatbotDslApi.Worker, [arg1, arg2, arg3]),
    ]

    # FIXME: This is really not the right way to do this but yolo, intentional
    # race condition!  To be clear, this exists so that the Repo will already
    # be started by the time we start the chatbots
    :timer.apply_after(5_000, ChatbotDslApi, :start_chatbots, [])

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ChatbotDslApi.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    ChatbotDslApi.Endpoint.config_change(changed, removed)
    :ok
  end

  def start_chatbots() do
    create_initial_chatbots()
    Repo.all(Chatbot)
    |> Enum.map(&Chatbot.ensure_started/1)
  end

  def create_initial_chatbots do
    # This is just a little dummy function to get us some seeds until we're comfy with everything
    Repo.delete_all(Rule)
    Repo.delete_all(Chatbot)
    chatbot1 = Repo.insert!(%Chatbot{name: "flipparooni"})
    chatbot2 = Repo.insert!(%Chatbot{name: "macabre"})
    rule1 = %Rule{ast: @json_tableflip_ast, chatbot_id: chatbot1.id}
    rule2 = %Rule{ast: @macabre_ast, chatbot_id: chatbot2.id}
    Repo.insert!(rule1)
    Repo.insert!(rule2)
  end
end
