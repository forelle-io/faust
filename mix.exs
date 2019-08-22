defmodule Faust.MixProject do
  use Mix.Project

  def project do
    [
      app: :faust,
      version: "0.1.10",
      elixir: ">= 1.8.1",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ]
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Faust.Application, []},
      extra_applications: [:logger, :runtime_tools, :edeliver, :scrivener_ecto, :scrivener_html]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      # Phoenix зависимости
      {:phoenix, "~> 1.4.9"},
      {:phoenix_pubsub, "~> 1.1"},
      {:phoenix_html, "~> 2.13.2"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:phoenix_ecto, "~> 4.0"},
      # Базы данных и хранилища
      {:ecto_sql, "~> 3.0"},
      {:postgrex, ">= 0.15.0"},
      # Пагинация
      {:scrivener_ecto, "~> 2.2.0"},
      {:scrivener_html, "~> 1.8.1"},
      # Локализация
      {:gettext, "~> 0.11"},
      # Сервера, форматы, протоколы
      {:jason, "~> 1.0"},
      {:plug_cowboy, "~> 2.0"},
      # Безопасность
      {:bcrypt_elixir, "~> 2.0"},
      {:guardian, "~> 2.0.0"},
      {:basic_auth, "~> 2.2.2"},
      {:bodyguard, "~> 2.4.0"},
      # Мультимедия
      {:alchemic_avatar,
       git: "https://github.com/solov9ev/alchemic_avatar", branch: "support-global-path"},
      # Релиз, деплой
      {:edeliver, ">= 1.6.0"},
      {:distillery, "~> 2.0.14", warn_missing: false},
      # Тестирование, инспекция кода, фикстуры, фабрики
      {:excoveralls, "~> 0.10", only: :test},
      {:credo, "~> 1.1.3", only: [:dev, :test], runtime: false},
      {:ex_machina, "~> 2.3", only: :test}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end
end
