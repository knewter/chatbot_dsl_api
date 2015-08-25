defmodule ChatbotDslApi.Integration.RulesTest do
  use ExUnit.Case

  alias ChatbotDslApi.Support.APICall
  alias ChatbotDslApi.Repo
  alias ChatbotDslApi.Chatbot
  alias ChatbotDslApi.Rule

  setup_all do
    ExUnitApiDocumentation.start_doc("rules")
    ChatbotDslApi.Helpers.launch_api
    Repo.delete_all(Rule)
    Repo.delete_all(Chatbot)
    chatbot_response = APICall.post!("/chatbots", %{chatbot: %{name: "foo"}})
    chatbot_id = chatbot_response.body.data.id

    on_exit fn ->
      # actually write out the docs
      ExUnitApiDocumentation.write_json
    end

    {:ok, chatbot_id: chatbot_id}
  end

  test "POST /api/rules returns HTTP 201", %{chatbot_id: chatbot_id} do
    response = APICall.post!("/chatbots/#{chatbot_id}/rules", %{rule: %{ast: "1 + 1"}})
    assert response.status_code == 201
  end

  test "invalid input in POST /api/rules returns HTTP 422", %{chatbot_id: chatbot_id} do
    response = APICall.post!("/chatbots/#{chatbot_id}/rules", %{rule: %{ast: ""}})
    assert response.status_code == 422
  end
end
