defmodule ChatbotDslApi.Integration.RulesTest do
  use ExUnit.Case

  alias ChatbotDslApi.Support.APICall

  setup_all do
    ExUnitApiDocumentation.start_doc("rules")
    ChatbotDslApi.Helpers.launch_api

    on_exit fn ->
      # actually write out the docs
      ExUnitApiDocumentation.write_json
    end

    :ok
  end

  test "POST /api/rules returns HTTP 201" do
    response = APICall.post!("/rules", %{rule: %{ast: "1 + 1"}})
    assert response.status_code == 201
  end

  test "invalid input in POST /api/rules returns HTTP 422" do
    response = APICall.post!("/rules", %{rule: %{ast: ""}})
    assert response.status_code == 422
  end
end
