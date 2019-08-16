defmodule Faust.Repo.Migrations.CreateOrganization do
  use Ecto.Migration

  def change do
    create table(:"accounts.organizations") do
      add :name, :string, null: false
      add :description, :text
      add :address, :string, null: false
      add :credential_id, references(:"accounts.credentials")

      timestamps()
    end

    create unique_index(:"accounts.organizations", :credential_id)
  end
end
