defmodule Faust.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  alias Faust.Accounts.{Credential, User}

  def change do
    accounts_users_tn = Faust.fetch_table_name(%User{})

    create table(accounts_users_tn) do
      add :name, :string, null: false
      add :surname, :string, null: false
      add :birthday, :date
      add :sex, :string
      add :avatar_timestamp, :string

      add :credential_id,
          references(Faust.fetch_table_name(%Credential{}), on_delete: :delete_all)

      timestamps()
    end

    create unique_index(accounts_users_tn, :credential_id)
  end
end
