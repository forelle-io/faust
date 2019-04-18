defmodule Faust.Repo.Migrations.CreateWaters do
  use Ecto.Migration

  def change do
    create table(:waters) do
      add :name, :string
      add :description, :text
      add :is_frozen, :boolean
      add :user_id, references(:users, on_delete: :delete_all)

      timestamps()
    end

    create index(:waters, [:user_id])
  end
end
