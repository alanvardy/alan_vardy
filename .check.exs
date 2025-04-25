env = %{"MIX_ENV" => "test"}
require_files = ["test/test_helper.exs"]

[
  retry: false,
  tools: [
    {:formatter, command: "mix format"},
    {:ex_coveralls, command: "mix coveralls.html", require_files: require_files, env: env},
    {:credo, command: "mix credo --strict"},
    {:ex_unit, enable: false},
    {:gettext, enable: false}
  ]
]
