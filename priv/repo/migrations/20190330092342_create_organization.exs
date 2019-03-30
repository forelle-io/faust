defmodule Faust.Repo.Migrations.CreateOrganization do
  use Ecto.Migration

  def change do
    create table(:organization) do
      add :name, :string, null: false
      add :description, :text
      add :address, :string, null: false
      add :credential_id, references(:credentials)

      timestamps()
    end
  end
end
