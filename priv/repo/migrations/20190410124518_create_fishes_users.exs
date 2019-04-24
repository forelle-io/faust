defmodule Faust.Repo.Migrations.CreateUsersFishes do
  use Ecto.Migration

  def change do
    create table(:fishes_users, primary_key: false) do
      add :fish_id, references(:fishes, on_delete: :delete_all)
      add :user_id, references(:users, on_delete: :delete_all)
    end

    create index(:fishes_users, [:fish_id])
    create index(:fishes_users, [:user_id])
    create unique_index(:fishes_users, [:fish_id, :user_id])
  end
end
