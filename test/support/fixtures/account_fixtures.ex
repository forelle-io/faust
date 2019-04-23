defmodule Faust.Support.AccountFixtures do
  @moduledoc false

  alias Faust.Accounts
  alias Faust.Accounts.{Chief, Credential, Organization, User}

  @credential_attrs %{
    unique: "unique",
    email: "unique@forelle.io",
    phone: "+79999999999",
    password: "password",
    password_confirmation: "password"
  }

  @user_attrs %{
    name: "Name",
    surname: "Surname",
    birthday: ~D[2000-01-01],
    credential: @credential_attrs
  }

  @organization_attrs %{
    name: "Name",
    description: "Description",
    address: "Address",
    credential: @credential_attrs
  }

  @chief_attrs %{
    credential: @credential_attrs
  }

  def credential_attrs, do: @credential_attrs

  def user_attrs, do: @user_attrs

  def organization_attrs, do: @organization_attrs

  def chief_attrs, do: @chief_attrs

  def credential_fixture(attrs \\ %{}) do
    {:ok, %Credential{} = credential} =
      attrs
      |> Enum.into(@credential_attrs)
      |> Accounts.create_credential()

    credential
  end

  def user_fixture(attrs \\ %{}) do
    {:ok, %User{} = user} =
      attrs
      |> Enum.into(@user_attrs)
      |> Accounts.create_user()

    user
  end

  def organization_fixture(attrs \\ %{}) do
    {:ok, %Organization{} = organization} =
      attrs
      |> Enum.into(@organization_attrs)
      |> Accounts.create_organization()

    organization
  end

  def chief_fixture(attrs \\ %{}) do
    {:ok, %Chief{} = chief} =
      attrs
      |> Enum.into(@chief_attrs)
      |> Accounts.create_chief()

    chief
  end
end
