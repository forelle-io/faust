defmodule Faust.Repo.Migrations.CreateTechniquesUsers do
  use Ecto.Migration

  alias Faust.Accounts.User
  alias Faust.Fishing.{Technique, TechniqueUser}

  def change do
    fishing_techniques_users_tn = Faust.fetch_table_name(%TechniqueUser{})

    create table(fishing_techniques_users_tn, primary_key: false) do
      add :technique_id, references(Faust.fetch_table_name(%Technique{}), on_delete: :delete_all), null: false
      add :user_id, references(Faust.fetch_table_name(%User{}), on_delete: :delete_all), null: false
    end

    create index(fishing_techniques_users_tn, [:technique_id])
    create index(fishing_techniques_users_tn, [:user_id])
    create unique_index(fishing_techniques_users_tn, [:technique_id, :user_id])
  end
end
