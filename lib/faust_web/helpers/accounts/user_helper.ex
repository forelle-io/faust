defmodule FaustWeb.Accounts.UserHelper do
  @moduledoc false

  alias Faust.Accounts
  alias Faust.Repo
  alias FaustWeb.FishHelper
  alias FaustWeb.TechniqueHelper

  def user_preloads(current_user, required_user_id) do
    if current_user && current_user.id == String.to_integer(required_user_id) do
      Repo.preload(current_user, [:fishes, :techniques])
    else
      required_user_id
      |> Accounts.get_user!()
      |> Repo.preload([:credential, :fishes, :techniques])
    end
  end

  def handle_user_params(user, user_params) do
    user_params
    |> FishHelper.fetch_fishes_params(user.fishes)
    |> TechniqueHelper.fetch_techniques_params(user.techniques)
  end
end
