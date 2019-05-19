defmodule Faust.AccountsTest do
  @moduledoc false

  use Faust.DataCase

  import Faust.Support.{AccountFixtures, Factories}

  alias Faust.Accounts
  alias Faust.Accounts.{Chief, Credential, Organization, User}
  alias Faust.Repo

  describe "credentials" do
    test "list_credentials/0 возврат всех удостоверений" do
      insert_list(5, :credential)

      assert Accounts.list_credentials() |> length() == 5
    end

    test "get_credential!/1 возврат удостоверения по переданному id" do
      credential = insert(:credential)

      with %Credential{id: id} <- Accounts.get_credential!(credential.id) do
        assert credential.id == id
      end
    end

    test "create_credential/1 с валидными данными создание удостоверения" do
      {:ok, %Credential{} = credential} =
        credential_attrs()
        |> Accounts.create_credential()

      assert credential.unique == "unique"
      assert credential.email == "unique@forelle.io"
      assert Bcrypt.verify_pass("password", credential.password_hash)
    end

    test "create_credential/1 с невалидными данными возврат ошибочного changeset" do
      assert {:error, %Ecto.Changeset{} = changeset} = Accounts.create_credential(%{unique: nil})
    end

    test "update_credential/2 с валидными данными обновление удостоверения" do
      credential = insert(:credential)

      assert {:ok, %Credential{} = credential} =
               Accounts.update_credential(credential, %{email: "faust@forelle.io"})

      assert credential.email == "faust@forelle.io"
      assert Bcrypt.verify_pass("password", credential.password_hash)
    end

    test "update_credential/2 с невалидными данными возврат ошибочного changeset" do
      credential = insert(:credential)

      assert {:error, %Ecto.Changeset{}} = Accounts.update_credential(credential, %{email: nil})
    end

    test "delete_credential/1 удаление удостоверения" do
      credential = insert(:credential)

      assert {:ok, %Credential{}} = Accounts.delete_credential(credential)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_credential!(credential.id) end
    end

    test "change_credential/1 возврат changeset удостоверения" do
      credential = insert(:credential)

      assert %Ecto.Changeset{} = Accounts.change_credential(credential)
    end

    test "repo_preload/2 проверка двухсторонней связи с пользователем" do
      user = user_fixture()

      %Credential{user: %User{id: user_id}} =
        user.credential.id
        |> Accounts.get_credential!()
        |> Repo.preload(:user)

      assert user_id == user.id
    end

    test "repo_preload/2 проверка двухсторонней связи с организацией" do
      organization = organization_fixture()

      %Credential{organization: %Organization{id: organization_id}} =
        organization.credential.id
        |> Accounts.get_credential!()
        |> Repo.preload(:organization)

      assert organization_id == organization.id
    end

    test "repo_preload/2 проверка двухсторонней связи с шефом" do
      chief = chief_fixture()

      %Credential{chief: %Chief{id: chief_id}} =
        chief.credential.id
        |> Accounts.get_credential!()
        |> Repo.preload(:chief)

      assert chief_id == chief.id
    end
  end

  describe "organization" do
    test "list_organization/0 возврат всех организаций" do
      insert_list(5, :organization)

      assert Accounts.list_organization() |> length() == 5
    end

    test "get_organization!/1 возврат организации по переданному id" do
      organization = insert(:organization)

      with %Organization{id: id} <- Accounts.get_organization!(organization.id) do
        assert organization.id == id
      end
    end

    test "create_organization/1 с валидными данными создание организации" do
      {:ok, %Organization{} = organization} =
        organization_attrs()
        |> Accounts.create_organization()

      assert organization.name == "Name"
      assert organization.address == "Address"
    end

    test "create_organization/1 с невалидными данными возврат ошибочного changeset" do
      assert {:error, %Ecto.Changeset{} = changeset} = Accounts.create_credential(%{name: nil})
    end

    test "update_organization/2 с валидными данными обновление организации" do
      organization = insert(:organization)

      assert {:ok, %Organization{} = organization} =
               Accounts.update_organization(organization, %{
                 name: "Faust",
                 description: "Description",
                 address: "Address"
               })

      assert organization.name == "Faust"
      assert organization.description == "Description"
      assert organization.address == "Address"
    end

    test "update_organization/2 с невалидными данными возврат ошибочного changeset" do
      organization = insert(:organization)

      assert {:error, %Ecto.Changeset{}} =
               Accounts.update_organization(organization, %{name: nil, address: nil})
    end

    test "delete_organization/1 удаление организации" do
      organization = insert(:organization)

      assert {:ok, %Organization{}} = Accounts.delete_organization(organization)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_organization!(organization.id) end
    end

    test "change_organization/1 возврат changeset организации" do
      organization = insert(:organization)

      assert %Ecto.Changeset{} = Accounts.change_organization(organization)
    end
  end

  describe "chief" do
    test "list_chief/0 возврат всех шефов" do
      insert_list(5, :chief)

      assert Accounts.list_chief() |> length() == 5
    end

    test "get_chief!/1 возврат шефа по переданному id" do
      chief = insert(:chief)

      with %Chief{id: id} <- Accounts.get_chief!(chief.id) do
        assert chief.id == id
      end
    end

    test "create_chief/1 с валидными данными создание шефа" do
      {:ok, %Chief{} = chief} =
        chief_attrs()
        |> Accounts.create_chief()

      assert chief
    end

    test "create_chief/1 с невалидными данными возврат ошибочного changeset" do
      assert {:error, %Ecto.Changeset{} = changeset} = Accounts.create_chief(%{})
    end

    test "delete_chief/1 удаление шефа" do
      chief = insert(:chief)

      assert {:ok, %Chief{}} = Accounts.delete_chief(chief)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_chief!(chief.id) end
    end

    test "change_chief/1 возврат changeset шефа" do
      chief = insert(:chief)

      assert %Ecto.Changeset{} = Accounts.change_chief(chief)
    end
  end

  describe "user" do
    test "list_user/0 возврат всех пользователей" do
      insert_list(5, :user)

      assert Accounts.list_users() |> length() == 5
    end

    test "get_user!/1 возврат пользователя по переданному id" do
      user = insert(:user)

      with %User{id: id} <- Accounts.get_user!(user.id) do
        assert user.id == id
      end
    end

    test "create user/1 с валидными данными" do
      {:ok, %User{} = user} =
        user_attrs()
        |> Accounts.create_user()

      assert user.name == "Name"
      assert user.surname == "Surname"
    end

    test "create_user/1 с невалидными данными возврат ошибочного changeset" do
      assert {:error, %Ecto.Changeset{} = changeset} = Accounts.create_user(%{name: nil})
    end

    test "update_user/2 с валидными данными и с новым видом рыбы" do
      user =
        :user
        |> insert()
        |> Repo.preload(:fishes)

      fish = insert(:fish)

      assert {:ok, %User{} = user} =
               Accounts.update_user(user, %{
                 name: "Faust",
                 surname: "Newsurname",
                 birthday: ~D[2000-05-01],
                 fishes_ids: [fish.id]
               })

      assert user.name == "Faust"
      assert user.surname == "Newsurname"
      assert user.birthday == ~D[2000-05-01]

      assert Repo.preload(user, :fishes).fishes |> length() == 1
    end

    test "update_user/2 с валидными данными и с новой техникой ловли" do
      user =
        :user
        |> insert()
        |> Repo.preload(:techniques)

      technique = insert(:technique)

      assert {:ok, %User{} = user} =
               Accounts.update_user(user, %{
                 name: "Faust",
                 surname: "Newsurname",
                 birthday: ~D[2000-05-01],
                 techniques_ids: [technique.id]
               })

      assert user.name == "Faust"
      assert user.surname == "Newsurname"
      assert user.birthday == ~D[2000-05-01]

      assert Repo.preload(user, :techniques).techniques |> length() == 1
    end

    test "update_user/2 с обновление пользователя" do
      user = insert(:user)

      assert {:ok, %User{} = user} =
               Accounts.update_user(user, %{
                 name: "Faust",
                 surname: "Newsurname",
                 birthday: ~D[2000-05-01]
               })

      assert user.name == "Faust"
      assert user.surname == "Newsurname"
      assert user.birthday == ~D[2000-05-01]
    end

    test "update_user/2 с невалидными данными возврат ошибочного changeset" do
      user = insert(:user)

      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, %{name: nil, surname: nil})
    end

    test "delete user/1 удаление пользователя" do
      user = insert(:user)

      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "change_user/1 возврат changeset пользователя" do
      user = insert(:user)

      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end
end
