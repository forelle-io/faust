defmodule FaustWeb.TechniquesView do
  use FaustWeb, :view

  alias Faust.Fishing

  def techniques_for_multiple_select do
    {_, list_techniques} = :ets.lookup(:hot_tables, "fishing.techniques") |> List.first()
    list_techniques
  end

  def techniques_tags(_conn, []), do: ""

  def techniques_tags(conn, techniques) when is_list(techniques) do
    Enum.reduce(techniques, "", fn technique, acc ->
      link =
        technique.name
        |> link(to: Routes.user_path(conn, :index), class: "topic")
        |> Phoenix.HTML.safe_to_string()

      acc <> link
    end)
  end
end
