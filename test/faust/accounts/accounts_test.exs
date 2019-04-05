defmodule Faust.AccountsTest do
  @moduledoc false

  use Faust.DataCase

  import Faust.Support.{AccountFixtures, Factories}

  alias Faust.Accounts
  alias Faust.Accounts.{Credential, Organization, Chief, User}

  describe "credentials" do
    test "list_credentials/0 returns all credentials" do
      insert_list(5, :credential)

      assert Accounts.list_credentials() |> length() == 5
    end

    test "get_credential!/1 returns the credential with given id" do
      credential = insert(:credential)

      with %Credential{id: id} <- Accounts.get_credential!(credential.id) do
        assert credential.id == id
      end
    end

    test "create_credential/1 with valid data creates a credential" do
      {:ok, %Credential{} = credential} =
        credential_attrs()
        |> Accounts.create_credential()

      assert credential.unique == "unique"
      assert credential.email == "unique@forelle.io"
      assert Bcrypt.verify_pass("password", credential.password_hash)
    end

    test "create_credential/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{} = changeset} = Accounts.create_credential(%{unique: nil})
    end

    test "update_credential/2 with valid data updates the credential" do
      credential = insert(:credential)

      assert {:ok, %Credential{} = credential} =
               Accounts.update_credential(credential, %{email: "faust@forelle.io"})

      assert credential.email == "faust@forelle.io"
      assert Bcrypt.verify_pass("password", credential.password_hash)
    end

    test "update_credential/2 with invalid data returns error changeset" do
      credential = insert(:credential)

      assert {:error, %Ecto.Changeset{}} = Accounts.update_credential(credential, %{email: nil})
    end

    test "delete_credential/1 deletes the credential" do
      credential = insert(:credential)

      assert {:ok, %Credential{}} = Accounts.delete_credential(credential)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_credential!(credential.id) end
    end

    test "change_credential/1 returns a credential changeset" do
      credential = insert(:credential)

      assert %Ecto.Changeset{} = Accounts.change_credential(credential)
    end
  end

  describe "organization" do
    test "list_organization/0 returns all organization" do
      insert_list(5, :organization)

      assert Accounts.list_organization() |> length() == 5
    end

    test "get_organization!/1 returns the organization with given id" do
      organization = insert(:organization)

      with %Organization{id: id} <- Accounts.get_organization!(organization.id) do
        assert organization.id == id
      end
    end

    test "create_organization/1 with valid data creates a organization" do
      {:ok, %Organization{} = organization} =
        organization_attrs()
        |> Accounts.create_organization()

      assert organization.name == "Name"
      assert organization.address == "Address"
    end

    test "create_organization/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{} = changeset} = Accounts.create_credential(%{name: nil})
    end

    test "update_organization/2 with valid data updates the organization" do
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

    test "update_organization/2 with invalid data returns error changeset" do
      organization = insert(:organization)

      assert {:error, %Ecto.Changeset{}} =
               Accounts.update_organization(organization, %{name: nil, address: nil})
    end

    test "delete_organization/1 deletes the organization" do
      organization = insert(:organization)

      assert {:ok, %Organization{}} = Accounts.delete_organization(organization)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_organization!(organization.id) end
    end

    test "change_organization/1 returns a organization changeset" do
      organization = insert(:organization)

      assert %Ecto.Changeset{} = Accounts.change_organization(organization)
    end
  end

  describe "chief" do
    test "list_chief/0 returns all chief" do
      insert_list(5, :chief)

      assert Accounts.list_chief() |> length() == 5
    end

    test "get_chief!/1 returns the chief with given id" do
      chief = insert(:chief)

      with %Chief{id: id} <- Accounts.get_chief!(chief.id) do
        assert chief.id == id
      end
    end

    test "create_credential/1 with valid data creates a credential" do
      {:ok, %Credential{} = credential} =
        credential_attrs()
        |> Accounts.create_credential()

      assert credential.unique == "unique"
      assert credential.email == "unique@forelle.io"
      assert Bcrypt.verify_pass("password", credential.password_hash)
    end

    test "create_credential/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{} = changeset} = Accounts.create_credential(%{unique: nil})
    end

    test "update_credential/2 with valid data updates the credential" do
      credential = insert(:credential)

      assert {:ok, %Credential{} = credential} =
               Accounts.update_credential(credential, %{email: "faust@forelle.io"})

      assert credential.email == "faust@forelle.io"
      assert Bcrypt.verify_pass("password", credential.password_hash)
    end

    test "update_credential/2 with invalid data returns error changeset" do
      credential = insert(:credential)

      assert {:error, %Ecto.Changeset{}} = Accounts.update_credential(credential, %{email: nil})
    end

    test "delete_credential/1 deletes the credential" do
      credential = insert(:credential)

      assert {:ok, %Credential{}} = Accounts.delete_credential(credential)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_credential!(credential.id) end
    end

    test "change_credential/1 returns a credential changeset" do
      credential = insert(:credential)

      assert %Ecto.Changeset{} = Accounts.change_credential(credential)
    end
  end

  describe "user" do
    test "list_user/0 returns all user" do
      insert_list(5, :user)

      assert Accounts.list_users() |> length() == 5
    end

    test "get_user!/1 returns the user with given id" do
      user = insert(:user)

      with %User{id: id} <- Accounts.get_user!(user.id) do
        assert user.id == id
      end
    end

    test "create user/1 with valid data creates a user" do
      {:ok, %User{} = user} =
        user_attrs()
        |> Accounts.create_user()

      assert user.name == "Name"
      assert user.surname == "Surname"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{} = changeset} = Accounts.create_user(%{name: nil})
    end

    test "update_user/2 with valid data updates the user" do
      user = insert(:user)

      assert {:ok, %User{} = user} =
               Accounts.update_user(user, %{
                 name: "Faust",
                 surname: "NewSurname",
                 birthday: ~D[2000-05-01]
               })

      assert user.name == "Faust"
      assert user.surname == "NewSurname"
      assert user.birthday == ~D[2000-05-01]
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = insert(:user)

      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, %{name: nil, surname: nil})
    end

    test "delete user/1 deletes the user" do
      user = insert(:user)

      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = insert(:user)

      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end
end
