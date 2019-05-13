defmodule Faust.Reservoir.Water do
  @moduledoc false

  use Ecto.Schema

  import Ecto.{Changeset, Query}

  alias __MODULE__
  alias Faust.Accounts.User
  alias Faust.Fishing.{Fish, FishWater, Technique, TechniqueWater}
  alias Faust.Reservoir.History
  alias FaustWeb.Reservoir.WaterPolicy

  @colors ["коричневый", "зеленый", "синий", "прозрачный"]
  @types ["море", "озеро", "пруд", "река", "водохранилище", "карьер"]
  @bottom_types ["илистое", "песчаное", "каменистое", "вязкое", "скалистое", "подводные леса"]
  @environments ["лес", "степь", "луг", "поле", "сад"]

  schema "reservoir.waters" do
    field :name, :string
    field :description, :string
    field :is_frozen, :boolean
    field :latitude, :float, default: 55.7458
    field :longitude, :float, default: 37.6227
    field :type, :string
    field :bottom_type, :string
    field :color, :string
    field :environment, :string

    field :fishes_ids, :any, virtual: true
    field :techniques_ids, :any, virtual: true

    timestamps()

    has_many :histories, History

    many_to_many :fishes, Fish,
      join_through: Faust.fetch_table_name(%FishWater{}, %{atomize: false}),
      on_replace: :delete

    many_to_many :techniques, Technique,
      join_through: Faust.fetch_table_name(%TechniqueWater{}, %{atomize: false}),
      on_replace: :delete

    belongs_to :user, User
  end

  def types, do: @types
  def colors, do: @colors
  def bottom_types, do: @bottom_types
  def environments, do: @environments

  defdelegate authorize(action, current_user, resource), to: WaterPolicy

  # Changesets -----------------------------------------------------------------

  def create_changeset(water, attrs) do
    water
    |> cast(attrs, [
      :name,
      :description,
      :is_frozen,
      :fishes_ids,
      :techniques_ids,
      :latitude,
      :longitude,
      :type,
      :bottom_type,
      :color,
      :environment
    ])
    |> validate_required([:name, :description, :is_frozen])
    |> put_assoc(:user, attrs["user"], required: true)
    |> Fish.fishes_pipeline()
    |> Technique.techniques_pipeline()
  end

  def update_changeset(water, attrs) do
    water
    |> cast(attrs, [
      :name,
      :description,
      :is_frozen,
      :fishes_ids,
      :techniques_ids,
      :latitude,
      :longitude,
      :type,
      :bottom_type,
      :color,
      :environment
    ])
    |> validate_required([:name, :description, :is_frozen])
    |> Fish.fishes_pipeline()
    |> Technique.techniques_pipeline()
  end

  # SQL запросы ----------------------------------------------------------------

  def list_water_query(user_id) do
    from w in Water,
      where: w.user_id == ^user_id
  end
end
