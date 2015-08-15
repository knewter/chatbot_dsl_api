defmodule ChatbotDslApi.RuleView do
  use ChatbotDslApi.Web, :view

  def render("index.json", %{rules: rules}) do
    %{data: render_many(rules, ChatbotDslApi.RuleView, "rule.json")}
  end

  def render("show.json", %{rule: rule}) do
    %{data: render_one(rule, ChatbotDslApi.RuleView, "rule.json")}
  end

  def render("rule.json", %{rule: rule}) do
    %{id: rule.id}
  end
end
