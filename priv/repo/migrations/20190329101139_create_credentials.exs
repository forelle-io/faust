defmodule Faust.Repo.Migrations.CreateCredentials do
  use Ecto.Migration

  def change do
    create table(:credentials) do
      add :unique, :string, null: false
      add :email, :string, null: false
      add :phone, :string
      add :password_hash, :string, null: false

      timestamps()
    end
  end
end
