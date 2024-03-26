defmodule AlanVardy.MixProject do
  use Mix.Project

  def project do
    [
      app: :alan_vardy,
      version: "0.1.0",
      elixir: "~> 1.13",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      test_coverage: [tool: ExCoveralls],
      aliases: aliases(),
      dialyzer: [
        plt_add_apps: [:ex_unit, :mix],
        list_unused_filters: true,
        plt_local_path: "dialyzer/local_plt",
        plt_core_path: "dialyzer/core_plt",
        flags: [:missing_return, :extra_return, :unmatched_returns]
      ],
      deps: deps(),
      preferred_cli_env: [
        check: :test,
        credo: :test,
        dialyzer: :test,
        doctor: :test,
        "coveralls.html": :test,
        "coveralls.json": :test
      ]
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {AlanVardy.Application, []},
      extra_applications: [:logger, :runtime_tools]
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
      {:phoenix, "~> 1.7.2"},
      {:phoenix_view, "~> 2.0"},
      {:phoenix_html, "~> 3.0"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:phoenix_live_view, "~> 0.18.3"},
      {:floki, ">= 0.30.0", only: :test},
      {:phoenix_live_dashboard, "~> 0.7.2"},
      {:ecto, "~> 3.5"},
      {:phoenix_ecto, "~> 4.0"},
      {:esbuild, "~> 0.3", runtime: Mix.env() == :dev},
      {:swoosh, "~> 1.3"},
      {:telemetry_metrics, "~> 1.0"},
      {:telemetry_poller, "~> 1.0"},
      {:gettext, "~> 0.18"},
      {:jason, "~> 1.2"},
      {:plug_cowboy, "~> 2.5"},
      {:tailwind, "~> 0.1", runtime: Mix.env() == :dev},
      {:postex, "~> 0.1"},
      {:ex_robo_cop, "~> 0.1.4"},
      {:hackney, "~> 1.9"},
      {:ex_check, "~> 0.12", only: :test, runtime: false},
      {:credo, "~> 1.4", only: :test, runtime: false},
      {:dialyxir, "~> 1.0", only: :test, runtime: false},
      {:excoveralls, "~> 0.13", only: :test, runtime: false},
      {:doctor, "~> 0.21.0", only: :test}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: ["deps.get"],
      "assets.deploy": ["esbuild default --minify", "phx.digest"]
    ]
  end
end
