defmodule Faust.Repo.Migrations.CreateCredentials do
  use Ecto.Migration

  def change do
    create table(:"accounts.credentials") do
      add :unique, :string, null: false
      add :email, :string, null: false
      add :phone, :string
      add :password_hash, :string, null: false
      add :alchemic_avatar, :string

      timestamps()
    end

    create unique_index(:"accounts.credentials", :unique)
    create unique_index(:"accounts.credentials", :email)
  end
end
