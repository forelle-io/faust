defmodule Faust.Fishing.TechniqueUser do
  @moduledoc false

  use Ecto.Schema

  alias Faust.Fishing.Technique
  alias Faust.Accounts.User

  @primary_key false

  schema "fishing.techniques_users" do
    belongs_to(:techniques, Technique)
    belongs_to(:users, User)
  end
end
