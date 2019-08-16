defmodule Faust.Repo.Migrations.CreateFishesUsers do
  use Ecto.Migration

  def change do
    create table(:"fishing.fishes_users", primary_key: false) do
      add :fish_id, references(:"fishing.fishes", on_delete: :delete_all), null: false

      add :user_id, references(:"accounts.users", on_delete: :delete_all), null: false
    end

    create index(:"fishing.fishes_users", [:fish_id])
    create index(:"fishing.fishes_users", [:user_id])
    create unique_index(:"fishing.fishes_users", [:fish_id, :user_id])
  end
end
