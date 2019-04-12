defmodule Faust.Repo.Migrations.CreateFishes do
  use Ecto.Migration

  def change do
    create table(:fishes) do
      add :name, :string
    end
  end
end
