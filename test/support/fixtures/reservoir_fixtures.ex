defmodule Faust.Support.ReservoirFixtures do
  @moduledoc false

  alias Faust.Accounts.User
  alias Faust.Reservoir.{History, Water}

  @water_attrs %{
    "name" => "Золотой карась",
    "description" => "Описание водоема",
    "is_frozen" => true,
    "latitude" => 0.0,
    "longitude" => 0.0,
    "type" => "озеро",
    "bottom_type" => "песчаное",
    "color" => "прозрачный",
    "environment" => "лес"
  }

  @history_atrs %{
    "type" => "зарыбление",
    "description" => "Запуск форели средней навеской по 1кг общим весом 500кг"
  }

  def water_attrs(%User{} = user, attrs \\ %{}) do
    @water_attrs
    |> Map.merge(attrs)
    |> Map.put_new("user", user)
  end

  def history_attrs(%Water{} = water, attrs \\ %{}) do
    @history_atrs
    |> Map.merge(attrs)
    |> Map.put_new("water", water)
  end

  def water_fixture(%User{} = user, attrs \\ %{}) do
    {:ok, %Water{} = water} =
      attrs
      |> Enum.into(water_attrs(user))
      |> Faust.Reservoir.create_water()

    water
  end

  def history_fixture(%Water{} = water, attrs \\ %{}) do
    {:ok, %History{} = history} =
      attrs
      |> Enum.into(history_attrs(water))
      |> Faust.Reservoir.create_history()

    history
  end
end
