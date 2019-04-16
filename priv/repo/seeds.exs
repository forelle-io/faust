require Logger

alias Ecto.Multi
alias Faust.Fishing.Fish

# Заполнение таблицы fishes названиями рыб
fishes = [
  "белый амур",
  "берш",
  "голавль",
  "густера",
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

try do
  Multi.new()
  |> Multi.insert_all(:insert_all, Fish, Enum.map(fishes, &%{name: &1}))
  |> Faust.Repo.transaction()
rescue
  e in Postgrex.Error ->
    with %Postgrex.Error{postgres: %{code: code, message: message}} <- e do
      Logger.error("Ошибка с кодом: #{code} и сообщением: #{message}")
    end
end
