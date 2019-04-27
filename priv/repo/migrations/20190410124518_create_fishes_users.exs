defmodule Faust.Repo.Migrations.CreateFishesUsers do
  use Ecto.Migration

  alias Faust.Accounts.User
  alias Faust.Fishing.{Fish, FishUser}

  def change do
    fishing_fishes_users_tn = Faust.fetch_table_name(%FishUser{})
    fishing_fishes_tn = Faust.fetch_table_name(%Fish{})
    accounts_users_tn = Faust.fetch_table_name(%User{})

    create table(fishing_fishes_users_tn, primary_key: false) do
      add :fish_id, references(fishing_fishes_tn, on_delete: :delete_all)
      add :user_id, references(accounts_users_tn, on_delete: :delete_all)
    end

    create index(fishing_fishes_users_tn, [:fish_id])
    create index(fishing_fishes_users_tn, [:user_id])
    create unique_index(fishing_fishes_users_tn, [:fish_id, :user_id])
  end
end
