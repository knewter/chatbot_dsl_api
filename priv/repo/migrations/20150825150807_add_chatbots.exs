defmodule ChatbotDslApi.Repo.Migrations.AddChatbots do
  use Ecto.Migration

  def change do
    create table(:chatbots) do
      add :name, :string

      timestamps
    end

    alter table(:rules) do
      add :chatbot_id, references(:chatbots)
    end
  end
end
