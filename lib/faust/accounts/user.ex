defmodule Faust.Accounts.User do
  @moduledoc false

  use Ecto.Schema

  import Ecto.{Changeset, Query}

  alias __MODULE__
  alias Ecto.Changeset
  alias Faust.Accounts.Credential
  alias Faust.Snoop.Follower
  alias Faust.Fishing.{Fish, FishUser, Technique, TechniqueUser}
  alias Faust.Reservoir.Water
  alias FaustWeb.Accounts.UserPolicy

  @regex_name ~r/\A[A-ZА-Я]{1}[a-zа-я]+\z/u
  @sex ["не выбран", "мужской", "женский"]

  schema "accounts.users" do
    field :name, :string
    field :surname, :string
    field :birthday, :date
    field :sex, :string

    field :fishes_ids, :any, virtual: true
    field :techniques_ids, :any, virtual: true

    timestamps()

    has_many :waters, Water

    many_to_many :fishes, Fish,
      join_through: Faust.fetch_table_name(%FishUser{}, "string"),
      on_replace: :delete

    many_to_many :techniques, Technique,
      join_through: Faust.fetch_table_name(%TechniqueUser{}, "string"),
      on_replace: :delete

    many_to_many :followee, User,
      join_through: Follower,
      join_keys: [user_id: :id, follower_id: :id],
      on_replace: :delete

    many_to_many :followers, User,
      join_through: Follower,
      join_keys: [follower_id: :id, user_id: :id],
      on_replace: :delete

    belongs_to :credential, Credential
  end

  defdelegate authorize(action, current_user, resource), to: UserPolicy
  def sex, do: @sex

  # Changesets -----------------------------------------------------------------

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :surname])
    |> validate_required([:name, :surname])
    |> validate_format(:name, @regex_name)
    |> validate_format(:surname, @regex_name)
    |> cast_assoc(:credential, with: &Credential.create_changeset/2, required: true)
  end

  def create_changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :surname])
    |> validate_required([:name, :surname])
    |> validate_format(:name, @regex_name)
    |> validate_format(:surname, @regex_name)
    |> cast_assoc(:credential, with: &Credential.create_changeset/2, required: true)
  end

  def update_changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :surname, :birthday, :sex, :fishes_ids, :techniques_ids])
    |> validate_required([:name, :surname])
    |> cast_assoc(:credential, with: &Credential.update_changeset/2, required: true)
    |> validate_format(:name, @regex_name)
    |> validate_inclusion(:sex, @sex)
    |> sex_modify_changes()
    |> Fish.fishes_modify_changes()
    |> Technique.techniques_modify_changes()
  end

  defp sex_modify_changes(%Changeset{changes: changes} = changeset) do
    case changes do
      %{sex: "не выбран"} ->
        Changeset.put_change(changeset, :sex, nil)

      _ ->
        changeset
    end
  end

  # SQL запрос -----------------------------------------------------------------

  def list_users_by_filter_query(filter) do
    query = from(u in User)

    query
    |> filter_name_surname_like_query(filter["search"])
    |> filter_sex_query(filter["sex"])
  end

  defp filter_name_surname_like_query(query, search) do
    if is_bitstring(search) and String.length(search) > 0 do
      query
      |> where([u], ilike(u.name, ^"%#{search}%"))
      |> or_where([u], ilike(u.surname, ^"%#{search}%"))
    else
      query
    end
  end

  defp filter_sex_query(query, sex) when sex in ["мужской", "женский"] do
    where(query, [u], u.sex == ^sex)
  end

  defp filter_sex_query(query, _sex), do: query
end
