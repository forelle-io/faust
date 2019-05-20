defmodule Faust.Accounts.OrganizationTest do
  @moduledoc false

  use Faust.DataCase

  import Faust.Support.Factories
  import Faust.Support.AccountFixtures, only: [organization_attrs: 0]

  alias Faust.Accounts
  alias Faust.Accounts.Organization

  describe "list_organizations/0" do
    test "когда записи organizations отсутствуют" do
      assert Accounts.list_organizations() |> Enum.empty?()
    end

    test "когда записи organizations присутствуют в количестве 5" do
      insert_list(5, :accounts_organization)

      assert Accounts.list_organizations() |> length() == 5
    end
  end

  describe "get_organization!/1" do
    test "когда запись organization отсутствует" do
      assert_raise Ecto.NoResultsError, fn ->
        Accounts.get_organization!(1)
      end
    end

    test "когда запись organization присутствует" do
      %Organization{id: id} = insert(:accounts_organization)
      organization = Accounts.get_organization!(id)

      assert organization.id == id
    end
  end

  describe "get_organization/1" do
    test "когда запись organization отсутствует" do
      refute Accounts.get_organization(1)
    end

    test "когда запись organization присутствует" do
      %Organization{id: id} = insert(:accounts_organization)
      organization = Accounts.get_organization(id)

      assert organization.id == id
    end
  end

  describe "create_organization/1" do
    test "когда данные не валидны" do
      {:error, %Ecto.Changeset{errors: errors} = changeset} =
        organization_attrs()
        |> Map.merge(%{"name" => nil, "address" => nil})
        |> Accounts.create_organization()

      refute changeset.valid?

      assert errors[:name] == {"can't be blank", [validation: :required]}
      assert errors[:address] == {"can't be blank", [validation: :required]}
    end

    test "когда данные валидны" do
      assert {:ok, %Organization{}} = organization_attrs() |> Accounts.create_organization()
    end
  end

  describe "update_organization/2" do
    test "когда данные не валидны" do
      {:error, %Ecto.Changeset{errors: errors} = changeset} =
        :accounts_organization
        |> insert()
        |> Accounts.update_organization(%{"name" => nil, "address" => nil})

      refute changeset.valid?

      assert errors[:name] == {"can't be blank", [validation: :required]}
      assert errors[:address] == {"can't be blank", [validation: :required]}
    end

    test "когда данные валидны" do
      {:ok, organization} =
        :accounts_organization
        |> insert()
        |> Accounts.update_organization(%{
          "name" => "Толстый карп",
          "address" => "Ярославская область, деревня Березки"
        })

      assert organization.name == "Толстый карп"
      assert organization.address == "Ярославская область, деревня Березки"
    end
  end

  describe "delete_organization/1" do
    test "когда запись organization присутствует" do
      organization = insert(:accounts_organization)

      assert {:ok, %Organization{}} = Accounts.delete_organization(organization)

      assert_raise Ecto.NoResultsError, fn ->
        Accounts.get_organization!(organization.id)
      end
    end
  end

  describe "change_organization/1" do
    test "когда запись organization присутствует" do
      assert %Ecto.Changeset{} =
               :accounts_organization
               |> insert()
               |> Accounts.change_organization()
    end

    test "когда запись organization отсутствует" do
      assert %Ecto.Changeset{errors: errors, valid?: false} =
               Accounts.change_organization(%Organization{})

      assert errors[:name] == {"can't be blank", [validation: :required]}
      assert errors[:address] == {"can't be blank", [validation: :required]}
    end
  end
end
