defmodule Faust.Repo.Migrations.CreateTechniquesUsers do
  use Ecto.Migration

  def change do
    create table(:"fishing.techniques_users", primary_key: false) do
      add :technique_id, references(:"fishing.techniques", on_delete: :delete_all), null: false

      add :user_id, references(:"accounts.users", on_delete: :delete_all), null: false
    end

    create index(:"fishing.techniques_users", [:technique_id])
    create index(:"fishing.techniques_users", [:user_id])
    create unique_index(:"fishing.techniques_users", [:technique_id, :user_id])
  end
end
