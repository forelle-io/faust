require Logger

alias Ecto.Multi
alias Faust.Fishing.{Fish, Technique}

Logger.info("Заполнение таблицы fishing.fishes названиями рыб")

fishes = [
  "белый амур",
  "берш",
  "голавль",
  "ерш",
  "жерех",
  "карась",
  "карп",
  "красноперка",
  "лещ",
  "линь",
  "лосось",
  "налим",
  "окунь",
  "пескарь",
  "плотва",
  "сазан",
  "сом",
  "стерлядь",
  "судак",
  "толстолобик",
  "угорь",
  "уклейка",
  "форель",
  "хариус",
  "щука",
  "язь"
]

Multi.new()
|> Multi.insert_all(:insert_all, Fish, Enum.map(fishes, &%{name: &1}))
|> Faust.Repo.transaction()

Logger.info("Заполнение таблицы fishing.techniques техниками ловли")

techniques = [
  "поплавочная удочка",
  "донная снасть",
  "фидер",
  "спиннинг",
  "джиггинг",
  "нахлыст",
  "сбирулино",
  "троллинг",
  "жерлица",
  "кружок"
]

Multi.new()
|> Multi.insert_all(:insert_all, Technique, Enum.map(techniques, &%{name: &1}))
|> Faust.Repo.transaction()
