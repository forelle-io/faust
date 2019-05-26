defmodule Faust.Support.Factories do
  @moduledoc false

  use ExMachina.Ecto, repo: Faust.Repo

  alias Faust.Accounts.{Chief, Credential, Organization, User}
  alias Faust.Crypto
  alias Faust.Fishing.{Fish, Technique}
  alias Faust.Reservoir.{History, Water}
  alias Faust.Snoop.Follower

  # Account context ------------------------------------------------------------

  def accounts_credential_factory do
    unique = Crypto.generate_unique_alphabet_string(8)

    phone =
      Enum.reduce(1..10, "", fn _, acc ->
        (0..9 |> Enum.random() |> Integer.to_string()) <> acc
      end)

    %Credential{
      unique: unique,
      phone: "+7#{phone}",
      email: "#{unique}@gmail.com",
      password_hash: "$2b$12$a9nZxyHHNkajJNyMazL6W.GPVoZ0TVvr/P4Fer4pnNqvAXc/Tv9hi"
    }
  end

  def accounts_user_factory do
    %User{
      name: sequence(:name, ["Алексей", "Кирилл", "Илья"]),
      surname: sequence(:surname, ["Иванов", "Петров", "Сидоров"]),
      birthday: sequence(:surname, [~D[1994-05-03], ~D[1996-06-04], ~D[1984-07-05]]),
      credential: build(:accounts_credential)
    }
  end

  def accounts_organization_factory do
    %Organization{
      name: sequence(:name, ["Золотой карась", "Радужная форель", "Зубастая щука"]),
      description:
        sequence(:description, [
          "Экологически чистый естественный проточный водоем",
          "Мы находимся в живописнейшем нетронутом лесу",
          "Наше болото — самое лучшее!"
        ]),
      address:
        sequence(:address, [
          "Московская область, Москва, МКАД 69 км",
          "Курская область, деревня Будановка",
          "Орловская область, деревня Пескари"
        ]),
      credential: build(:accounts_credential)
    }
  end

  def accounts_chief_factory do
    %Chief{credential: build(:accounts_credential)}
  end

  # Fishing context ------------------------------------------------------------

  def fishing_fish_factory do
    unique = Crypto.generate_unique_alphabet_string(4)

    %Fish{
      name:
        sequence(
          :name,
          Enum.map(
            ["карась", "карп", "стерлядь", "форель", "щука"],
            &"#{&1}_#{unique}"
          )
        )
    }
  end

  def fishing_technique_factory do
    unique = Crypto.generate_unique_alphabet_string(4)

    %Technique{
      name:
        sequence(
          :name,
          Enum.map(["фидер", "спиннинг", "джиггинг", "нахлыст", "сбирулино"], &"#{&1}_#{unique}")
        )
    }
  end

  # Reservoir context ----------------------------------------------------------

  def reservoir_water_factory do
    %Water{
      name: sequence(:name, ["Большой пруд", "Малый пруд", "Нижний карьер", "Основной карьер"]),
      description:
        sequence(:description, [
          "Очищенная береговая территория идеально подходит для ловли на удочку, штекер и удобного заброса фидера, а вычищенное дно и русло пруда позволяют не беспокоится о корягах и зацепах.",
          "Вода имеет специфический черный цвет, обьясняемый природой водоема.",
          "Вокруг водоема посадка молодых березок, а так же стоят беседки с мангалами где вы можете отдохнуть и порыбачить с семьей.",
          "В наших прудах можно поймать форель, карпа, сома, щуку, осетра, окуня."
        ]),
      is_frozen: :rand.uniform(2) / 2 == 1,
      user: build(:accounts_user)
    }
  end

  def reservoir_history_factory do
    %History{
      type: sequence(:name, History.types()),
      description:
        sequence(:description, [
          "Добро пожаловать",
          "Приносим свои извинения",
          "Запустили рыбу",
          "До свидания"
        ]),
      water: build(:reservoir_water)
    }
  end

  # Snoop context --------------------------------------------------------------

  def snoop_follower_factory do
    %Follower{
      users: build(:accounts_user),
      followers: build(:accounts_user)
    }
  end
end
