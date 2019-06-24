defmodule Faust.Repo.Migrations.AddAvatarToAccountsUserTable do
  use Ecto.Migration

  alias Faust.Accounts.User

  def change do
    accounts_users_tn = Faust.fetch_table_name(%User{})

    alter table(accounts_users_tn) do
      add :avatar, :string
    end
  end
end
