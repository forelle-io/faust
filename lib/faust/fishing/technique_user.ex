defmodule Faust.Fishing.TechniqueUser do
  @moduledoc false

  use Ecto.Schema

  alias Faust.Accounts.User
  alias Faust.Fishing.Technique

  @primary_key false

  schema "fishing.techniques_users" do
    belongs_to(:techniques, Technique, foreign_key: :technique_id)
    belongs_to(:users, User, foreign_key: :user_id)
  end
end
