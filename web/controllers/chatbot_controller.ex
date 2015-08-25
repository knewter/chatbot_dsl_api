defmodule ChatbotDslApi.ChatbotController do
  use ChatbotDslApi.Web, :controller

  alias ChatbotDslApi.Chatbot

  plug :scrub_params, "chatbot" when action in [:create, :update]

  def index(conn, _params) do
    chatbots = Repo.all(Chatbot)
    render(conn, "index.json", chatbots: chatbots)
  end

  def create(conn, %{"chatbot" => chatbot_params}) do
    changeset = Chatbot.changeset(%Chatbot{}, chatbot_params)

    case Repo.insert(changeset) do
      {:ok, chatbot} ->
        conn
        |> put_status(:created)
        |> render("show.json", chatbot: chatbot)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(ChatbotDslApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    chatbot = Repo.get!(Chatbot, id)
    render conn, "show.json", chatbot: chatbot
  end

  def update(conn, %{"id" => id, "chatbot" => chatbot_params}) do
    chatbot = Repo.get!(Chatbot, id)
    changeset = Chatbot.changeset(chatbot, chatbot_params)

    case Repo.update(changeset) do
      {:ok, chatbot} ->
        render(conn, "show.json", chatbot: chatbot)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(ChatbotDslApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    chatbot = Repo.get!(Chatbot, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    chatbot = Repo.delete!(chatbot)

    send_resp(conn, :no_content, "")
  end
end
