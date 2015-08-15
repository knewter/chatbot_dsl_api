defmodule ChatbotDslApi.Rule do
  use ChatbotDslApi.Web, :model

  schema "rules" do
    field :ast, :string

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

  def apply(rule, input) do
    ast = JsonAstConverter.convert(rule.ast)
    compiled = ast |> Compiler.compile
    compiled.(input)
  end
end