defmodule Faust.Repo.Migrations.CreateChief do
  use Ecto.Migration

  def change do
    create table(:"accounts.chiefs") do
      add :credential_id, references(:"accounts.credentials")

      timestamps()
    end

    create unique_index(:"accounts.chiefs", :credential_id)
  end
end
