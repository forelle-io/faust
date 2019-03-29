defmodule Faust.AccountsTest do
  @moduledoc false

  use Faust.DataCase

  alias Faust.Accounts

  describe "credentials" do
    alias Faust.Accounts.Credential

    @valid_attrs %{
      unique: "faust",
      email: "faust@forelle.io",
      password: "l1nxld7f",
      password_confirmation: "l1nxld7f"
    }
    @update_attrs %{
      email: "unknown@forelle.io",
      password: "kmdy3gbr",
      password_confirmation: "kmdy3gbr"
    }
    @invalid_attrs %{password: "lm23rd7", password_confirmation: "lm23rd8"}

    def credential_fixture(attrs \\ %{}) do
      {:ok, credential} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_credential()

      credential
    end

    test "list_credentials/0 returns all credentials" do
      credential_fixture()

      Accounts.list_credentials()
      |> Enum.each(&assert &1 = %Credential{})
    end

    test "get_credential!/1 returns the credential with given id" do
      credential = credential_fixture()
      assert Accounts.get_credential!(credential.id).id == credential.id
    end

    test "create_credential/1 with valid data creates a credential" do
      assert {:ok, %Credential{} = credential} = Accounts.create_credential(@valid_attrs)
      assert credential.unique == "faust"
      assert credential.email == "faust@forelle.io"
      assert Bcrypt.verify_pass("l1nxld7f", credential.password_hash)
    end

    test "create_credential/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_credential(@invalid_attrs)
    end

    test "update_credential/2 with valid data updates the credential" do
      credential = credential_fixture()

      assert {:ok, %Credential{} = credential} =
               Accounts.update_credential(credential, @update_attrs)

      assert credential.email == "unknown@forelle.io"
      assert Bcrypt.verify_pass("kmdy3gbr", credential.password_hash)
    end

    test "update_credential/2 with invalid data returns error changeset" do
      credential = credential_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_credential(credential, @invalid_attrs)
    end

    test "delete_credential/1 deletes the credential" do
      credential = credential_fixture()
      assert {:ok, %Credential{}} = Accounts.delete_credential(credential)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_credential!(credential.id) end
    end

    test "change_credential/1 returns a credential changeset" do
      credential = credential_fixture()
      assert %Ecto.Changeset{} = Accounts.change_credential(credential)
    end
  end
end
