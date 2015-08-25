defmodule ChatbotDslApi.ChatbotControllerTest do
  use ChatbotDslApi.ConnCase

  alias ChatbotDslApi.Chatbot
  @valid_attrs %{name: "some name"}
  @invalid_attrs %{}

  setup do
    conn = conn() |> put_req_header("accept", "application/json")
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, chatbot_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    chatbot = Repo.insert! %Chatbot{}
    conn = get conn, chatbot_path(conn, :show, chatbot)
    assert json_response(conn, 200)["data"] == %{
      "id" => chatbot.id,
      "name" => chatbot.name
    }
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, chatbot_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, chatbot_path(conn, :create), chatbot: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Chatbot, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, chatbot_path(conn, :create), chatbot: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    chatbot = Repo.insert! %Chatbot{}
    conn = put conn, chatbot_path(conn, :update, chatbot), chatbot: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Chatbot, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    chatbot = Repo.insert! %Chatbot{}
    conn = put conn, chatbot_path(conn, :update, chatbot), chatbot: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    chatbot = Repo.insert! %Chatbot{}
    conn = delete conn, chatbot_path(conn, :delete, chatbot)
    assert response(conn, 204)
    refute Repo.get(Chatbot, chatbot.id)
  end
end
