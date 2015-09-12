defmodule ChatbotDslApi.RuleController do
  use ChatbotDslApi.Web, :controller

  alias ChatbotDslApi.Rule
  alias ChatbotDslApi.Chatbot

  plug :scrub_params, "rule" when action in [:create, :update]
  plug :find_chatbot

  def index(conn, _params) do
    rules = from r in Rule, where: r.chatbot_id == ^conn.assigns[:chatbot].id
            |> Repo.all
    render(conn, "index.json", rules: rules)
  end

  def create(conn, %{"rule" => rule_params}) do
    new_rule = build(conn.assigns.chatbot, :rules)
    changeset = Rule.changeset(new_rule, rule_params)

    case Repo.insert(changeset) do
      {:ok, rule} ->
        Chatbot.ensure_started(conn.assigns.chatbot)
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
    rule = Repo.get!(assoc(conn.assigns.chatbot, :rules), id)
    render conn, "show.json", rule: rule
  end

  def update(conn, %{"id" => id, "rule" => rule_params}) do
    rule = Repo.get!(Rule, id)
    changeset = Rule.changeset(rule, rule_params)

    case Repo.update(changeset) do
      {:ok, rule} ->
        Chatbot.ensure_started(conn.assigns.chatbot)
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

  defp find_chatbot(conn, _) do
    chatbot = Repo.get(ChatbotDslApi.Chatbot, conn.params["chatbot_id"])
    assign(conn, :chatbot, chatbot)
  end
end
