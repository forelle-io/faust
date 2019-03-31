defmodule Faust.Repo.Migrations.CreateChief do
  use Ecto.Migration

  def change do
    create table(:chief) do
      add :credential_id, references(:credentials)

      timestamps()
    end
  end
end
