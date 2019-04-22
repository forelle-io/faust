defmodule FaustWeb.FishView do
  use FaustWeb, :view

  alias Faust.Fishing

  def fishes_for_multiple_select do
    Enum.map(Fishing.list_fishes(), &{&1.name, &1.id})
  end

  def fishes_tags(conn, []), do: ""

  def fishes_tags(conn, fishes) when is_list(fishes) do
    Enum.reduce(fishes, "", fn fish, acc ->
      link =
        fish.name
        |> link(to: Routes.user_path(conn, :index), class: "topic")
        |> Phoenix.HTML.safe_to_string()

      acc <> link
    end)
  end
end
