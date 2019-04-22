defmodule Faust.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string, null: false
      add :surname, :string, null: false
      add :birthday, :date
      add :credential_id, references(:credentials, on_delete: :delete_all)

      timestamps()
    end

    create unique_index(:users, :credential_id)
  end
end
