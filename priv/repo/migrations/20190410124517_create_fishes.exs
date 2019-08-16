defmodule Faust.Repo.Migrations.CreateFishes do
  use Ecto.Migration

  def change do
    create table(:"fishing.fishes") do
      add :name, :string, null: false
    end

    create unique_index(:"fishing.fishes", :name)
  end
end
