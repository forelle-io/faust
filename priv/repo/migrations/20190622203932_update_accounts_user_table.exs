defmodule Faust.Repo.Migrations.UpdateAccountsUserTable do
  use Ecto.Migration

  alias Faust.Accounts.{Credential, User}

  def change do
    accounts_users_tn = Faust.fetch_table_name(%User{})

    alter table(accounts_users_tn) do
      add :avatar_timestamp, :string
    end
  end
end
