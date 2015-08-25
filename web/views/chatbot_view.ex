defmodule ChatbotDslApi.ChatbotView do
  use ChatbotDslApi.Web, :view

  def render("index.json", %{chatbots: chatbots}) do
    %{data: render_many(chatbots, ChatbotDslApi.ChatbotView, "chatbot.json")}
  end

  def render("show.json", %{chatbot: chatbot}) do
    %{data: render_one(chatbot, ChatbotDslApi.ChatbotView, "chatbot.json")}
  end

  def render("chatbot.json", %{chatbot: chatbot}) do
    %{id: chatbot.id, name: chatbot.name}
  end
end
