defmodule Faust.Repo.Migrations.CreateTechniquesUsers do
  use Ecto.Migration

  alias Faust.Accounts.User
  alias Faust.Fishing.{Technique, TechniqueUser}

  def change do
    fishing_techniques_users_tn = Faust.fetch_table_name(%TechniqueUser{})
    fishing_techniques_tn = Faust.fetch_table_name(%Technique{})
    accounts_users_tn = Faust.fetch_table_name(%User{})

    create table(fishing_techniques_users_tn, primary_key: false) do
      add :technique_id, references(fishing_techniques_tn, on_delete: :delete_all)
      add :user_id, references(accounts_users_tn, on_delete: :delete_all)
    end

    create index(fishing_techniques_users_tn, [:technique_id])
    create index(fishing_techniques_users_tn, [:user_id])
    create unique_index(fishing_techniques_users_tn, [:technique_id, :user_id])
  end
end
