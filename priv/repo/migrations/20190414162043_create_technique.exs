defmodule Faust.Repo.Migrations.CreateTechniques do
  use Ecto.Migration

  alias Faust.Fishing.Technique

  def change do
    fishing_techniques_tn = Faust.fetch_table_name(%Technique{})

    create table(fishing_techniques_tn) do
      add :name, :string, null: false
    end

    create unique_index(fishing_techniques_tn, :name)
  end
end
