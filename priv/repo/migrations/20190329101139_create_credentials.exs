defmodule Faust.Repo.Migrations.CreateCredentials do
  use Ecto.Migration

  alias Faust.Accounts.Credential

  def change do
    accounts_credentials_tn = Faust.fetch_table_name(%Credential{})

    create table(accounts_credentials_tn) do
      add :unique, :string, null: false
      add :email, :string, null: false
      add :phone, :string
      add :password_hash, :string, null: false

      timestamps()
    end

    create unique_index(accounts_credentials_tn, :unique)
    create unique_index(accounts_credentials_tn, :email)
  end
end
