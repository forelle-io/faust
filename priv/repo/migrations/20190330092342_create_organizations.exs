defmodule Faust.Repo.Migrations.CreateOrganization do
  use Ecto.Migration

  alias Faust.Accounts.{Credential, Organization}

  def change do
    accounts_organizations_tn = Faust.fetch_table_name(%Organization{})

    create table(accounts_organizations_tn) do
      add :name, :string, null: false
      add :description, :text
      add :address, :string, null: false
      add :credential_id, references(Faust.fetch_table_name(%Credential{}))

      timestamps()
    end

    create unique_index(accounts_organizations_tn, :credential_id)
  end
end
