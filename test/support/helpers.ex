defmodule ChatbotDslApi.Helpers do
  def launch_api do
    # set up config for serving
    endpoint_config =
      Application.get_env(:chatbot_dsl_api, ChatbotDslApi.Endpoint)
      |> Keyword.put(:server, true)
    :ok = Application.put_env(:chatbot_dsl_api, ChatbotDslApi.Endpoint, endpoint_config)

    # restart our application with serving enabled
    :ok = Application.stop(:chatbot_dsl_api)
    :ok = Application.start(:chatbot_dsl_api)
  end
end
