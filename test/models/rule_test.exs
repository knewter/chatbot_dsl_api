defmodule ChatbotDslApi.RuleTest do
  use ChatbotDslApi.ModelCase

  alias ChatbotDslApi.Rule
  alias ChatbotDslApi.Repo

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

  @valid_attrs %{ast: @json_ast}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Rule.changeset(%Rule{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Rule.changeset(%Rule{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "rule can be applied against an input" do
    changeset = Rule.changeset(%Rule{}, @valid_attrs)
    {:ok, rule} = Repo.insert(changeset)
    assert Rule.apply(rule, "bob is filthy")
  end
end
