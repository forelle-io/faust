defmodule Faust.Support.Factories do
  @moduledoc false

  use ExMachina.Ecto, repo: Faust.Repo

  alias Faust.Accounts.{Chief, Credential, Organization, User}
  alias Faust.Fishing.{Fish, Technique}
  alias Faust.Reservoir.Water

  def credential_factory do
    %Credential{
      unique: sequence(:unique, &"unique_#{&1}"),
      email: sequence(:email, &"unique#{&1}@forelle.io"),
      password_hash: "$2b$12$a9nZxyHHNkajJNyMazL6W.GPVoZ0TVvr/P4Fer4pnNqvAXc/Tv9hi"
    }
  end

  def user_factory do
    %User{
      name: sequence(:name, &"Name#{&1}"),
      surname: sequence(:surname, &"Surname#{&1}"),
      credential: build(:credential)
    }
  end

  def organization_factory do
    %Organization{
      name: sequence(:name, &"Name#{&1}"),
      description: sequence(:description, &"Description#{&1}"),
      address: sequence(:address, &"Address#{&1}"),
      credential: build(:credential)
    }
  end

  def chief_factory do
    %Chief{
      credential: build(:credential)
    }
  end

  def fish_factory do
    %Fish{
      name: sequence(:name, &"name#{&1}")
    }
  end

  def technique_factory do
    %Technique{
      name: sequence(:name, &"name#{&1}")
    }
  end

  def water_factory do
    %Water{
      name: sequence(:name, &"Name#{&1}"),
      description: sequence(:description, &"Description#{&1}"),
      is_frozen: false
    }
  end
end
