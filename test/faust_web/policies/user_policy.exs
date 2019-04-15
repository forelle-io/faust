defmodule FaustWeb.UserPolicyTest do
  @moduledoc false

  use Faust.DataCase

  import Faust.Support.Factories

  alias FaustWeb.UserPolicy

  setup do
    {:ok, current_user: insert(:user)}
  end

  describe "edit" do
    test "доступ разрешен", %{current_user: current_user} do
      assert UserPolicy.authorize(:edit, current_user, current_user)
    end

    test "доступ запрещен", %{current_user: current_user} do
      refute UserPolicy.authorize(:edit, current_user, insert(:user))
    end
  end

  describe "update" do
    test "доступ разрешен", %{current_user: current_user} do
      assert UserPolicy.authorize(:update, current_user, current_user)
    end

    test "доступ запрещен", %{current_user: current_user} do
      refute UserPolicy.authorize(:update, current_user, insert(:user))
    end
  end

  describe "delete" do
    test "доступ разрешен", %{current_user: current_user} do
      assert UserPolicy.authorize(:delete, current_user, current_user)
    end

    test "доступ запрещен", %{current_user: current_user} do
      refute UserPolicy.authorize(:delete, current_user, insert(:user))
    end
  end
end
