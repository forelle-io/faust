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

  @regex_name ~r/\A[a-zA-Zа-яА-Я ]+\z/u

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
      join_through: Faust.fetch_table_name(%FishWater{}, "string"),
      on_replace: :delete

    many_to_many :techniques, Technique,
      join_through: Faust.fetch_table_name(%TechniqueWater{}, "string"),
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
    |> validate_format(:name, @regex_name)
    |> validate_inclusion(:type, @types)
    |> validate_inclusion(:color, @colors)
    |> validate_inclusion(:bottom_type, @bottom_types)
    |> validate_inclusion(:environment, @environments)
    |> put_assoc(:user, attrs["user"], required: true)
    |> Fish.fishes_modify_changes()
    |> Technique.techniques_modify_changes()
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
    |> validate_format(:name, @regex_name)
    |> validate_inclusion(:type, @types)
    |> validate_inclusion(:color, @colors)
    |> validate_inclusion(:bottom_type, @bottom_types)
    |> validate_inclusion(:environment, @environments)
    |> Fish.fishes_modify_changes()
    |> Technique.techniques_modify_changes()
  end

  # SQL запросы ----------------------------------------------------------------

  def list_water_query(user_id) do
    from w in Water,
      where: w.user_id == ^user_id
  end

  def list_waters_by_filter_query(filter) do
    query = from(w in Water)

    query
    |> filter_type_query(filter["type"])
    |> filter_bottom_type_query(filter["bottom_type"])
    |> filter_color_query(filter["color"])
    |> filter_environment_query(filter["environment"])
  end

  # фильтры по типу водоема
  defp filter_type_query(query, type) when type in @types do
    where(query, [w], w.type == ^type)
  end

  defp filter_type_query(query, _type), do: query

  # фильтры по типу дна
  defp filter_bottom_type_query(query, bottom_type) when bottom_type in @bottom_types do
    where(query, [w], w.bottom_type == ^bottom_type)
  end

  defp filter_bottom_type_query(query, _bottom_type), do: query

  # фильтры по цвету воды
  defp filter_color_query(query, color) when color in @colors do
    where(query, [w], w.color == ^color)
  end

  defp filter_color_query(query, _color), do: query

  # фильтры по окружению
  defp filter_environment_query(query, environment) when environment in @environments do
    where(query, [w], w.environment == ^environment)
  end

  defp filter_environment_query(query, _environment), do: query
end
