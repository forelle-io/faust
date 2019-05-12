defmodule Faust.Repo.Migrations.CreateSnoopFollowers do
  use Ecto.Migration

  alias Faust.Accounts.User
  alias Faust.Snoop.Follower

  def change do
    snoop_followers_tn = Faust.fetch_table_name(%Follower{})
    accounts_users_tn = Faust.fetch_table_name(%User{})

    create table(snoop_followers_tn, primary_key: false) do
      add :user_id, references(accounts_users_tn),
        on_delete: :delete_all,
        null: false,
        primary_key: true

      add :follower_id, references(accounts_users_tn),
        on_delete: :delete_all,
        null: false,
        primary_key: true
    end

    create index(snoop_followers_tn, [:user_id])
    create index(snoop_followers_tn, [:follower_id])
  end
end
