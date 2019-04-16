defmodule Faust.Repo.Migrations.CreateUsersTechniques do
  use Ecto.Migration

  def change do
    create table(:techniques_users, primary_key: false) do
      add :user_id, references(:users, on_delete: :delete_all)
      add :technique_id, references(:techniques, on_delete: :delete_all)
    end

    create index(:techniques_users, [:user_id])
    create index(:techniques_users, [:technique_id])
    create unique_index(:techniques_users, [:user_id, :technique_id])
  end
end
