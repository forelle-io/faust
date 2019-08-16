defmodule Faust.Repo.Migrations.CreateTechniques do
  use Ecto.Migration

  def change do
    create table(:"fishing.techniques") do
      add :name, :string, null: false
    end

    create unique_index(:"fishing.techniques", :name)
  end
end
