defmodule FaustWeb.UserView do
  use FaustWeb, :view

  import FaustWeb.FishView, only: [fishes_for_multiple_select: 0]
  import FaustWeb.TechniquesView, only: [techniques_for_multiple_select: 0]
end
