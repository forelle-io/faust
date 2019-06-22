defmodule FaustWeb.Accounts.UserHelper do
  @moduledoc false

  alias Faust.Accounts
  alias Faust.Accounts.User
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

  # функция, для получения пути к картинки аватара
  def get_user_avatar(conn, %User{} = user) do
    if is_nil(user.avatar_timestamp) do
      user.credential.alchemic_avatar
    else
      file_extension = get_file_extension(user)
      "/images/users/#{user.id}/#{user.avatar_timestamp}/origin.#{file_extension}"
    end
  end

  # функция, для определения расширения
  defp get_file_extension(user) do
    cond do
      File.exists?("assets/static/images/users/#{user.id}/#{user.avatar_timestamp}/origin.png") ->
        value = "png"

      File.exists?("assets/static/images/users/#{user.id}/#{user.avatar_timestamp}/origin.jpg") ->
        value = "jpg"

      File.exists?("assets/static/images/users/#{user.id}/#{user.avatar_timestamp}/origin.gif") ->
        value = "gif"
    end
  end
end
