defmodule Faust.Repo.Migrations.CreateChief do
  use Ecto.Migration

  alias Faust.Accounts.{Chief, Credential}

  def change do
    accounts_chiefs_tn = Faust.fetch_table_name(%Chief{})

    create table(accounts_chiefs_tn) do
      add :credential_id, references(Faust.fetch_table_name(%Credential{}))

      timestamps()
    end

    create unique_index(accounts_chiefs_tn, :credential_id)
  end
end
