defmodule ChatbotDslApi.RuleControllerTest do
  use ChatbotDslApi.ConnCase

  alias ChatbotDslApi.Rule
  alias ChatbotDslApi.Chatbot

  @valid_attrs %{ast: "some content"}
  @invalid_attrs %{}

  setup do
    ChatbotDslApi.Repo.delete_all(Rule)
    ChatbotDslApi.Repo.delete_all(Chatbot)
    {:ok, chatbot} = %Chatbot{name: "foo"} |> Repo.insert
    conn = conn() |> put_req_header("accept", "application/json")
    {:ok, conn: conn, chatbot: chatbot}
  end

  test "lists all entries on index", %{conn: conn, chatbot: chatbot} do
    conn = get conn, chatbot_rule_path(conn, :index, chatbot)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn, chatbot: chatbot} do
    new_rule = build(chatbot, :rules)
    changeset = Rule.changeset(new_rule, %{"ast" => "1 + 2"})
    rule = Repo.insert!(changeset)
    conn = get conn, chatbot_rule_path(conn, :show, chatbot, rule)
    assert json_response(conn, 200)["data"] == %{
      "id" => rule.id,
      "ast" => "1 + 2"
    }
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn, chatbot: chatbot} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, chatbot_rule_path(conn, :show, chatbot, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn, chatbot: chatbot} do
    conn = post conn, chatbot_rule_path(conn, :create, chatbot), rule: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Rule, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn, chatbot: chatbot} do
    conn = post conn, chatbot_rule_path(conn, :create, chatbot), rule: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn, chatbot: chatbot} do
    new_rule = build(chatbot, :rules)
    changeset = Rule.changeset(new_rule, %{"ast" => "1 + 2"})
    rule = Repo.insert!(changeset)
    conn = put conn, chatbot_rule_path(conn, :update, chatbot, rule), rule: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Rule, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn, chatbot: chatbot} do
    rule = Repo.insert! %Rule{}
    conn = put conn, chatbot_rule_path(conn, :update, chatbot, rule), rule: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn, chatbot: chatbot} do
    rule = Repo.insert! %Rule{}
    conn = delete conn, chatbot_rule_path(conn, :delete, chatbot, rule)
    assert response(conn, 204)
    refute Repo.get(Rule, rule.id)
  end
end
