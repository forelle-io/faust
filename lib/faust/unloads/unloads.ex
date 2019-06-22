defmodule FaustWeb.UserPhotoUploader do
  @moduledoc false

  def unload_user_avatar(user_params, id) do
    if upload = user_params["avatar_timestamp"] do
      # создание папок
      unless File.exists?("assets/static/images/users/#{id}") do
        File.mkdir!("assets/static/images/users/#{id}")
      end

      timestamp = DateTime.utc_now() |> DateTime.to_unix()
      File.mkdir!("assets/static/images/users/#{id}/#{timestamp}")

      # загрузка картинки
      extension = Path.extname(upload.filename)

      save_image =
        File.cp(upload.path, "assets/static/images/users/#{id}/#{timestamp}/origin#{extension}")

      user_avatar_timestamp = "#{timestamp}"
      %{user_params | "avatar_timestamp" => user_avatar_timestamp}
    else
      Map.put(user_params, "avatar_timestamp", nil)
    end
  end
end
