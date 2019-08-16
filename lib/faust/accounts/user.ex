defmodule Faust.Accounts.User do
  @moduledoc false

  use Ecto.Schema

  import Ecto.{Changeset, Query}

  alias __MODULE__
  alias Ecto.Changeset
  alias Faust.Accounts.Credential
  alias Faust.Snoop.{FollowerUser, FollowerWater}
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
    field :avatar, :string

    field :fishes_ids, :any, virtual: true
    field :techniques_ids, :any, virtual: true

    timestamps()

    has_many :waters, Water

    many_to_many :fishes, Fish,
      join_through: "fishing.fishes_users",
      on_replace: :delete

    many_to_many :techniques, Technique,
      join_through: "fishing.techniques_users",
      on_replace: :delete

    many_to_many :followee_users, User,
      join_through: FollowerUser,
      join_keys: [user_id: :id, follower_id: :id],
      on_replace: :delete

    many_to_many :follower_users, User,
      join_through: FollowerUser,
      join_keys: [follower_id: :id, user_id: :id],
      on_replace: :delete

    many_to_many :follower_waters, User,
      join_through: FollowerWater,
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
    |> cast(attrs, [
      :name,
      :surname,
      :birthday,
      :sex,
      :avatar,
      :fishes_ids,
      :techniques_ids
    ])
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

  def list_users_by_params_query(filter) do
    query = from(u in User)

    query
    |> filter_name_surname_like_query(filter["string"])
    |> filter_sex_query(filter["sex"])
    |> filter_fishes_ids_query(filter["fishes_ids"])
    |> filter_techniques_ids_query(filter["techniques_ids"])
  end

  defp filter_name_surname_like_query(query, string) do
    if is_bitstring(string) and String.length(string) > 0 do
      query
      |> where([u], ilike(u.name, ^"%#{string}%"))
      |> or_where([u], ilike(u.surname, ^"%#{string}%"))
    else
      query
    end
  end

  # credo:disable-for-lines:138 Credo.Check.Refactor.PipeChainStart
  def filter_fishes_ids_query(query, fishes_ids) do
    case fishes_ids do
      nil ->
        query

      [] ->
        query

      _ ->
        join(
          query,
          :inner,
          [u],
          subquery in ^subquery(
            from(u in User)
            |> join(:inner, [u], fu in FishUser,
              on: u.id == fu.user_id and fu.fish_id in ^fishes_ids
            )
            |> group_by([u], u.id)
            |> select([u], u.id)
          ),
          on: u.id == subquery.id
        )
    end
  end

  # credo:disable-for-lines:156 Credo.Check.Refactor.PipeChainStart
  def filter_techniques_ids_query(query, techniques_ids) do
    case techniques_ids do
      nil ->
        query

      [] ->
        query

      _ ->
        join(
          query,
          :inner,
          [u],
          subquery in ^subquery(
            from(u in User)
            |> join(:inner, [u], tu in TechniqueUser,
              on: u.id == tu.user_id and tu.technique_id in ^techniques_ids
            )
            |> group_by([u], u.id)
            |> select([u], u.id)
          ),
          on: u.id == subquery.id
        )
    end
  end

  defp filter_sex_query(query, sex) when sex in @sex do
    case sex do
      "не выбран" ->
        where(query, [u], is_nil(u.sex))

      _ ->
        where(query, [u], u.sex == ^sex)
    end
  end

  defp filter_sex_query(query, _sex), do: query
end
