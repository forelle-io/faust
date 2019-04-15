alias Ecto.Multi
alias Faust.Fishing.Fish

# Заполнение таблицы fishes названиями рыб
fishes =
  ~w(белый амур берш голавль густера ерш жерех карась карп карп красноперка лещ линь лосось налим окунь пескарь плотва сазан сом стерлядь судак толстолобик угорь уклейка форель хариус щука язь)

Multi.new()
|> Multi.insert_all(:insert_all, Fish, Enum.map(fishes, &%{name: &1}))
|> Faust.Repo.transaction()
