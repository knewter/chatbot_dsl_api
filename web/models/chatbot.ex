defmodule ChatbotDslApi.Chatbot do
  use ChatbotDslApi.Web, :model

  schema "chatbots" do
    field :name, :string
    has_many :rules, ChatbotDslApi.Rule

    timestamps
  end

  @required_fields ~w(name)
  @optional_fields ~w()

  @tableflip_ast {
    :if, [
      {
        :contains,
        [
          {:var, :input},
          ":tableflip:"
        ]
      },
      {
        :response,
        [
          "(╯°□°）╯︵ ┻━┻"
        ]
      }
    ]
  }

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end

  def registered_name(%__MODULE__{id: nil}), do: :error
  def registered_name(%__MODULE__{id: id}), do: {:ok, :"chatbot_#{id}"}

  def state(chatbot) do
    %ChatbotDSL.Chatbot.State{
      rules: [
        fn(%ChatbotDSL.Message{body: body}) ->
          ChatbotDSL.Compiler.compile(@tableflip_ast).(body)
        end,
      ]
    }
  end

  def ensure_started(chatbot) do
    {:ok, name} = registered_name(chatbot)
    stop(chatbot)
    {:ok, pid} = ChatbotDSL.Chatbot.start_link(state(chatbot))

    Process.register(pid, name)
  end

  def stop(chatbot) do
    {:ok, name} = registered_name(chatbot)
    case Process.whereis(name) do
      nil -> :ok
      pid -> :gen_server.stop(pid)
    end
  end
end
