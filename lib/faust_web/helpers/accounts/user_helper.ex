defmodule FaustWeb.Accounts.UserHelper do
  @moduledoc false

  alias Faust.Accounts
  alias Faust.Crypto
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
    case user_params do
      %{"avatar" => avatar} ->
        avatar_name =
          "user_#{user.id}_" <> Crypto.generate_unique_string(12) <> Path.extname(avatar.filename)

        Task.start(fn ->
          File.cp(avatar.path, "#{Faust.media_location()}/users/avatars/#{avatar_name}")
        end)

        %{"avatar" => avatar_name}

      _ ->
        user_params
        |> FishHelper.fetch_fishes_params(user.fishes)
        |> TechniqueHelper.fetch_techniques_params(user.techniques)
    end
  end

  def user_avatar_path(user) do
    avatar_path =
      if is_bitstring(user.avatar) and user.avatar != "" do
        "/avatars/#{user.avatar}"
      else
        "/alchemic_avatar/#{user.credential.alchemic_avatar}"
      end

    "/media/users" <> avatar_path
  end
end
