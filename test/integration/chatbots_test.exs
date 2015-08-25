defmodule ChatbotDslApi.Integration.ChatbotsTest do
  use ExUnit.Case

  alias ChatbotDslApi.Support.APICall

  setup_all do
    ExUnitApiDocumentation.start_doc("chatbots")
    ChatbotDslApi.Helpers.launch_api

    on_exit fn ->
      # actually write out the docs
      ExUnitApiDocumentation.write_json
    end

    :ok
  end

  test "POST /api/chatbots returns HTTP 201" do
    response = APICall.post!("/chatbots", %{chatbot: %{name: "gilligan"}})
    assert response.status_code == 201
  end

  test "invalid input in POST /api/chatbots returns HTTP 422" do
    response = APICall.post!("/chatbots", %{chatbot: %{name: ""}})
    assert response.status_code == 422
  end
end
