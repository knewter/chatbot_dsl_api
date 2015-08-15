defmodule ChatbotDslApi.Repo.Migrations.CreateRule do
  use Ecto.Migration

  def change do
    create table(:rules) do
      add :ast, :text

      timestamps
    end

  end
end
