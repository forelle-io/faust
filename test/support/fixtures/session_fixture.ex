defmodule Faust.Support.SessionFixtures do
  @moduledoc false

  import Faust.Support.AccountFixtures, only: [credential_attrs: 1]

  @session_user_attrs %{
    "association" => "user"
  }

  @session_organization_attrs %{
    "association" => "organization"
  }

  @session_chief_attrs %{
    "association" => "chief"
  }

  def session_user_attrs do
    :user
    |> credential_attrs()
    |> Map.merge(@session_user_attrs)
  end

  def session_organization_attrs do
    :organization
    |> credential_attrs()
    |> Map.merge(@session_organization_attrs)
  end

  def session_chief_attrs do
    :chief
    |> credential_attrs()
    |> Map.merge(@session_chief_attrs)
  end

  # defp session_attrs_bad_association do
  #   %{
  #     "association" => "bad_association",
  #     "password" => "password",
  #     "unique" => "solov9ev"
  #   }
  # end
end
