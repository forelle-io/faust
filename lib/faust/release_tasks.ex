defmodule Faust.ReleaseTasks do
  @moduledoc false

  def migrate do
    load_application()
    start_repo()

    Enum.each([:faust], &run_migrations_for/1)

    IO.puts("Success!")
    :init.stop()
  end

  def seed do
    load_application()
    start_repo()

    seed_script = Path.join([priv_dir(:faust), "repo", "seeds.exs"])

    if File.exists?(seed_script) do
      IO.puts("Running seed script..")
      Code.eval_file(seed_script)
    end

    IO.puts("Success!")
    :init.stop()
  end

  defp load_application do
    IO.puts("Starting dependencies..")
    Enum.each([:postgrex, :ecto, :ecto_sql], &Application.ensure_all_started/1)
  end

  defp start_repo do
    IO.puts("Starting repo..")
    Enum.each([Faust.Repo], & &1.start_link(pool_size: 2))
  end

  defp run_migrations_for(app) do
    IO.puts("Running migrations for #{app}")
    migrations_script = Path.join([priv_dir(app), "repo", "migrations"])
    Ecto.Migrator.run(Faust.Repo, migrations_script, :up, all: true)
  end

  defp priv_dir(app), do: "#{:code.priv_dir(app)}"
end
