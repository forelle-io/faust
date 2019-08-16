defmodule Faust.Repo.Migrations.CreateSnoopFollowers do
  use Ecto.Migration

  def change do
    create table(:"snoop.followers", primary_key: false) do
      add :user_id, references(:"accounts.users"),
        on_delete: :delete_all,
        null: false,
        primary_key: true

      add :follower_id, references(:"accounts.users"),
        on_delete: :delete_all,
        null: false,
        primary_key: true
    end

    create index(:"snoop.followers", [:user_id])
    create index(:"snoop.followers", [:follower_id])
  end
end
