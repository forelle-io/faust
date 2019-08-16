defmodule Faust.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:"accounts.users") do
      add :name, :string, null: false
      add :surname, :string, null: false
      add :birthday, :date
      add :sex, :string

      add :credential_id,
          references(:"accounts.credentials", on_delete: :delete_all)

      timestamps()
    end

    create unique_index(:"accounts.users", :credential_id)
  end
end
