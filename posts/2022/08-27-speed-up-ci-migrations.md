==title==
Speed up Elixir CI Migrations with Database dumps

==author==
Alan Vardy

==footer==

==description==
How to speed up PostgreSQL migrations on Continuous Integration services (and locally) using database structure dumps

==tags==
elixir,ecto,postgres

==body==

## The problem we are solving

Every time the test suite runs on a continuous integration service like CircleCI or GitHub Actions, the database usually needs to be created and migrated from scratch. It doesn't take long when the application is young and not many migrations have been created, but as the migrations folder grows so will the time that developers need to wait. Eventually, that wait becomes long enough (and running `mix ecto.reset` locally becomes painful enough) that utilizing database structure dumps becomes very attractive.

At the current company I work with we utilize multiple databases with many tables and migrating all of them locally (on a beefy Threadripper processor) takes ~ 142 seconds:

```bash
> time mix ecto.reset

Executed in  141.59 secs    fish           external
   usr time    2.85 secs  600.00 micros    2.85 secs
   sys time    0.57 secs  145.00 micros    0.57 secs
```

Whereas using the dump takes only ~ 38 seconds (I have overridden reset in my `mix.exs`)

```bash
> time mix ecto.reset

Executed in   38.27 secs    fish           external
   usr time    2.50 secs    0.00 micros    2.50 secs
   sys time    0.38 secs  712.00 micros    0.38 secs
```

That runtime improvement can be a huge difference when we are talking about the task executing on **every single CI run**.

## What is a structure dump and why is it faster than migrating?

A database structure dump is a record of the database structure, including the table, columns, indexes and constraints. It is NOT a record of the data (that would be a regular database dump), so you can expect all your tables to be empty of rows when loading a dump.

Instead of iterating over migrations one at a time, and having each run in a transaction, the whole database can be created from one file. Using a dump dramatically decreases the time necessary to create a database from scratch!

[Read more about pg_dump](https://www.postgresql.org/docs/current/app-pgdump.html)

## Are there disadvantages to using database structure dumps?

Yes. Once your migrations are transferred into the `dumped_migrations` folder and are no longer actively run on every CI build they will gradually begin to "rot". Helper functions that worked when the migration was executed will later change in ways that cause the migration to now fail. This will often not be discovered until a person, say, moves all those migrations back to the migrations folder and attempts to run them all.

Guess how I figured that out :)

Furthermore, database structure dumps will not be a feasible solution for your team if your team uses migrations to migrate data (which I honestly consider an anti-pattern). Structure dumps will not insert data and you will need to find another way.

## How we can use dumps alongside migrations

The usual order for generating a database from scratch is:

1. Create a database with `mix ecto.create`
2. Migrate the database with `mix ecto.migrate`

When using a structure dump file we can add a mix task in between steps 1 and 2 to load the structure.

1. Create a database with `mix ecto.create`
2. Load the structure dump with `mix ecto.load --force`
3. Migrate any remaining migrations that are not part of the dump yet with `mix ecto.migrate`

## How to create and update a structure dump

In order to generate an up-to-date structure dump we must first of all make sure that we have run all the migrations. Once we have created the dump we need to move the migrations to another folder so that they are not run again (because they are now part of the dump instead). This is what the process looks like:

1. Make sure that you are on the `main` branch
2. Run all your migrations on production (you don't want to commit a migration to the dump before it is run on prod)
3. Reset your database to make sure that it reflects `main` with `MIX_ENV=test mix ecto.reset`
4. Create the structure dump with `MIX_ENV=test mix ecto.dump` (see mix task below)
5. Move your dumped migrations with `MIX_ENV=test mix ecto.move_migrations` (see mix task below)

## Mix task to create dump

Create in `lib/mix/tasks/dump.ex`

```elixir
defmodule Mix.Tasks.Dump do
  @moduledoc """
  Mix task for dumping the structure.sql of the ecto repos. It filters out
  code comments and `SET`'s from the ecto.dump command to keep `git diff`s from
  becoming too annoying.
  """

  use Mix.Task

  import Mix.Ecto, only: [ensure_repo: 2, parse_repo: 1]
  import Mix.EctoSQL, only: [source_repo_priv: 1]

  @shortdoc "Dumps the databases to structure.sql"
  def run(args) do
    repos = parse_repo(args)

    Enum.each(repos, fn repo ->
      ensure_repo(repo, args)

      [repo, migration_repo(repo)]
      |> Stream.uniq()
      |> Enum.each(&dump_repo/1)
    end)
  end

  defp migration_repo(repo), do: repo.config()[:migration_repo] || repo

  defp dump_repo(repo) do
    config = repo.config()
    path = source_repo_priv(repo)

    with {:ok, file_path} <- Ecto.Adapters.Postgres.structure_dump(path, config),
         :ok <- File.rename(file_path, file_path <> ".io") do
      (file_path <> ".io")
      |> File.stream!(encoding: :utf8)
      |> Stream.reject(&String.starts_with?(&1, "--"))
      |> Stream.reject(&String.starts_with?(&1, "SET"))
      |> Stream.map(&schema_migrations_create_table_if_not_exists/1)
      |> Stream.map(&schema_migrations_pk_if_not_exists/1)
      |> Stream.scan(&remove_multiple_newlines/2)
      |> Stream.drop(4)
      |> Stream.into(File.stream!(file_path))
      |> Stream.run()

      File.rm!(file_path <> ".io")
    end
  end

  defp remove_multiple_newlines("\n", "\n"), do: ""
  defp remove_multiple_newlines("\n", ""), do: ""
  defp remove_multiple_newlines(line, _), do: line

  defp schema_migrations_create_table_if_not_exists(
         "CREATE TABLE public.schema_migrations" <> line
       ) do
    "CREATE TABLE IF NOT EXISTS public.schema_migrations" <> line
  end

  defp schema_migrations_create_table_if_not_exists(line), do: line

  defp schema_migrations_pk_if_not_exists("ALTER TABLE ONLY public.schema_migrations" <> _ = line) do
    drop_constraint_if_exists = """
    ALTER TABLE ONLY public.schema_migrations
        DROP CONSTRAINT IF EXISTS schema_migrations_pkey;
    """

    drop_constraint_if_exists <> "\n" <> line
  end

  defp schema_migrations_pk_if_not_exists(line), do: line
end
```

## Mix task to move migration files

Create in `lib/mix/tasks/move_migrations.ex`

```elixir
defmodule Mix.Tasks.MoveMigrations do
  @moduledoc """
  Mix task for moving mix files to the dumped_migrations folder after their
  changes have been rolled into the structure.sql dump files. This prevents
  them from being run again but keeps them as a reference.
  """

  use Mix.Task

  import Mix.Ecto, only: [ensure_repo: 2, parse_repo: 1]
  import Mix.EctoSQL, only: [source_repo_priv: 1]

  @source_files "/migrations"
  @destination "/dumped_migrations"

  @shortdoc "Moves all migrations to the dumped_migrations directory"
  def run(args) do
    repos = parse_repo(args)

    Enum.each(repos, fn repo ->
      ensure_repo(repo, args)

      [repo, migration_repo(repo)]
      |> Enum.uniq()
      |> Enum.each(&move_migration_files/1)
    end)
  end

  defp migration_repo(repo), do: repo.config()[:migration_repo] || repo

  defp move_migration_files(repo) do
    path = source_repo_priv(repo)

    File.mkdir_p!(path <> @destination)
    copied_files = File.cp_r!(path <> @source_files, path <> @destination)
    Enum.each(copied_files, &IO.puts("Moved file #{&1}"))

    (path <> @source_files)
    |> File.ls!()
    |> Enum.reject(&String.contains?(&1, ".gitkeep"))
    |> Enum.each(&File.rm!(path <> @source_files <> "/" <> &1))
  end
end
```

## Final thoughts

Strategically using database structure dumps can dramatically reduce the time developers need to wait while new databases are created from scratch. Since databases are created from scratch frequently, both locally and on CI, it can be a very useful optimization to save developers time.
