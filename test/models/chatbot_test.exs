defmodule ChatbotDslApi.ChatbotTest do
  use ChatbotDslApi.ModelCase

  alias ChatbotDslApi.Chatbot

  @json_ast """
  {
    "type": "if",
    "arguments": [
      {
        "type": "contains",
        "arguments": [
          {"type": "var", "arguments": [{"type": "atom", "arguments": ["input"]}]},
          {"type": "string", "arguments": ["filthy"]}
        ]
      },
      {"type": "atom", "arguments": ["true"]},
      {"type": "atom", "arguments": ["false"]}
    ]
  }
  """

  @valid_attrs %{name: "Some name"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Chatbot.changeset(%Chatbot{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Chatbot.changeset(%Chatbot{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "starting the underlying ChatbotDSL.Chatbot for our model" do
    chatbot = Repo.insert!(%Chatbot{name: "gigity"})
    Chatbot.ensure_started(chatbot)
    {:ok, name} = Chatbot.registered_name(chatbot)
    assert is_pid(Process.whereis(name))
  end
end
