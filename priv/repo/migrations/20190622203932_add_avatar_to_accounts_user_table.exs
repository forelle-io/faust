defmodule Faust.Repo.Migrations.AddAvatarToAccountsUserTable do
  use Ecto.Migration

  def change do
    alter table(:"accounts.users") do
      add :avatar, :string
    end
  end
end
