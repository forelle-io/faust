defmodule Faust.Repo.Migrations.CreateFishes do
  use Ecto.Migration

  alias Faust.Fishing.Fish

  def change do
    fishing_fishes_tn = Faust.fetch_table_name(%Fish{})

    create table(fishing_fishes_tn) do
      add :name, :string, null: false
    end

    create unique_index(fishing_fishes_tn, :name)
  end
end
