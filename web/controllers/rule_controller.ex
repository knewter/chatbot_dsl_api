defmodule ChatbotDslApi.RuleController do
  use ChatbotDslApi.Web, :controller

  alias ChatbotDslApi.Rule

  plug :scrub_params, "rule" when action in [:create, :update]

  def index(conn, _params) do
    rules = Repo.all(Rule)
    render(conn, "index.json", rules: rules)
  end

  def create(conn, %{"rule" => rule_params}) do
    changeset = Rule.changeset(%Rule{}, rule_params)

    case Repo.insert(changeset) do
      {:ok, rule} ->
        conn
        |> put_status(:created)
        |> render("show.json", rule: rule)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(ChatbotDslApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    rule = Repo.get!(Rule, id)
    render conn, "show.json", rule: rule
  end

  def update(conn, %{"id" => id, "rule" => rule_params}) do
    rule = Repo.get!(Rule, id)
    changeset = Rule.changeset(rule, rule_params)

    case Repo.update(changeset) do
      {:ok, rule} ->
        render(conn, "show.json", rule: rule)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(ChatbotDslApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    rule = Repo.get!(Rule, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    rule = Repo.delete!(rule)

    send_resp(conn, :no_content, "")
  end
end
