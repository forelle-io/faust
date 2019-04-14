defmodule Faust.Repo.Migrations.CreateChief do
  use Ecto.Migration

  def change do
    create table(:chiefs) do
      add :credential_id, references(:credentials)

      timestamps()
    end

    create unique_index(:chiefs, :credential_id)
  end
end
