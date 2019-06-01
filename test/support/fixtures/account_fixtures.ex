defmodule Faust.Support.AccountFixtures do
  @moduledoc false

  alias Faust.Accounts
  alias Faust.Accounts.{Chief, Credential, Organization, User}

  @credential_user_attrs %{
    "unique" => "solov9ev",
    "phone" => "+79999999999",
    "email" => "solov9ev@forelle.io",
    "password" => "password",
    "password_confirmation" => "password"
  }

  @credential_organization_attrs %{
    "unique" => "goldencarp",
    "phone" => "+79991111111",
    "email" => "admin@goldencarp.com",
    "password" => "password",
    "password_confirmation" => "password"
  }

  @credential_chief_attrs %{
    "unique" => "admin",
    "phone" => "+79990000000",
    "email" => "admin@forelle.io",
    "password" => "password",
    "password_confirmation" => "password"
  }

  @user_attrs %{
    "name" => "Alexey",
    "surname" => "Solovyev",
    "birthday" => ~D[1994-05-03],
    "credential" => @credential_user_attrs
  }

  @organization_attrs %{
    "name" => "Золотой карась",
    "description" => "Экологически чистый естественный проточный водоем",
    "address" => "Московская область, Москва, МКАД 69 км",
    "credential" => @credential_organization_attrs
  }

  @chief_attrs %{
    "credential" => @credential_chief_attrs
  }

  def credential_attrs(:user), do: @credential_user_attrs

  def credential_attrs(:organization), do: @credential_organization_attrs

  def credential_attrs(:chief), do: @credential_chief_attrs

  def user_attrs(attrs \\ %{}) do
    Enum.into(@user_attrs, attrs)
  end

  def organization_attrs, do: @organization_attrs

  def chief_attrs, do: @chief_attrs

  def credential_fixture(relation, attrs \\ %{})
      when relation in [:chief, :credential, :user] do
    default_attrs = apply(__MODULE__, :credential_attrs, [relation])

    {:ok, %Credential{} = credential} =
      attrs
      |> Enum.into(default_attrs)
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

  def other_user_fixture do
    %{
      user_attrs()
      | "credential" => %{
          credential_attrs(:user)
          | "email" => "other@forelle.io",
            "unique" => "other"
        },
        "name" => "Other",
        "surname" => "User"
    }
    |> user_fixture()
  end

  def other_organization_fixture do
    %{
      organization_attrs()
      | "credential" => %{
          credential_attrs(:user)
          | "email" => "other@forelle.io",
            "unique" => "other"
        },
        "name" => "Золотой карась",
        "address" => "Московская область, Москва, Арбатская д.9"
    }
    |> organization_fixture()
  end

  @spec organization_fixture(any()) :: Faust.Accounts.Organization.t()
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
