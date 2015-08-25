defmodule ChatbotDslApi.Rule do
  use ChatbotDslApi.Web, :model
  alias ChatbotDSL.JsonAstConverter
  alias ChatbotDSL.Compiler

  schema "rules" do
    field :ast, :string
    belongs_to :chatbot, ChatbotDslApi.Chatbot

    timestamps
  end

  @required_fields ~w(ast)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end

  def compile(rule) do
    rule.ast
    |> JsonAstConverter.convert
    |> Compiler.compile
  end

  def apply(rule, input) do
    compile(rule).(input)
  end
end
