defmodule FaustWeb.UserView do
  use FaustWeb, :view

  import FaustWeb.Accounts.UserHelper, only: [offset_rank_years: 0]
  import Scrivener.HTML
end
