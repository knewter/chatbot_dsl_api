defmodule ChatbotDslApi.Integration.RulesTest do
  use ExUnit.Case

  alias ChatbotDslApi.Support.APICall
  alias ChatbotDslApi.Repo
  alias ChatbotDslApi.Chatbot
  alias ChatbotDslApi.Rule

  setup_all do
    ChatbotDslApi.Helpers.launch_api
    Repo.delete_all(Rule)
    Repo.delete_all(Chatbot)
    chatbot_response = APICall.post!("/chatbots", %{chatbot: %{name: "foo"}})
    chatbot_id = chatbot_response.body.data.id

    {:ok, chatbot_id: chatbot_id}
  end

  test "POST /api/chatbots/:chatbot_id/rules returns HTTP 201", %{chatbot_id: chatbot_id} do
    response = APICall.post!("/chatbots/#{chatbot_id}/rules", %{rule: %{ast: "1 + 1"}})
    assert response.status_code == 201
  end

  test "invalid input in POST /api/chatbots/:chatbot_id/rules returns HTTP 422", %{chatbot_id: chatbot_id} do
    response = APICall.post!("/chatbots/#{chatbot_id}/rules", %{rule: %{ast: ""}})
    assert response.status_code == 422
  end

  test "PUT /api/chatbots/:chatbot_id/rules/:id returns HTTP 200", %{chatbot_id: chatbot_id} do
    post_response = APICall.post!("/chatbots/#{chatbot_id}/rules", %{rule: %{ast: "1+1"}})
    rule_id = post_response.body.data.id
    response = APICall.put!("/chatbots/#{chatbot_id}/rules/#{rule_id}", %{rule: %{id: rule_id, ast: "1+2"}})
    assert response.status_code == 200
  end
end
