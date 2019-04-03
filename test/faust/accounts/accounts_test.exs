defmodule Faust.AccountsTest do
  @moduledoc false

  use Faust.DataCase

  import Faust.Support.{AccountFixtures, Factories}

  alias Faust.Accounts
  alias Faust.Accounts.{Credential, Organization}

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
end
