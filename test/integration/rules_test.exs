defmodule ChatbotDslApi.Integration.RulesTest do
  use ExUnit.Case

  alias ChatbotDslApi.Support.APICall

  setup_all do
    ChatbotDslApi.Helpers.launch_api
  end

  test "POST /api/rules returns HTTP 201" do
    response = APICall.post!("/rules", %{rule: %{ast: "1 + 1"}})
    assert response.status_code == 201
  end
end
