==title==
How to cache Dialyzer on CI

==author==
Alan Vardy

==footer==

==description==
Speed up slow CI compile times by caching dialyzer persistent lookup tables

==tags==
elixir,erlang,dialyzer,ci

==body==

Dialyzer is not a fast compiling tool. Running it fresh can take a long time, especially if the project is large or the hardware running it is meager. When Dialyzer first starts, it creates a Persistent Lookup Table (PLT), a database of all the functions and all the typespecs. Then, it infers what it can from the functions, compares the functions and the typespecs. with each other in every combination possible and attempts to prove our code wrong. This lookup table is what takes so long to generate.

To not grow grey hair while waiting for Dialyzer to complete on Continuous Integration (CI), we must cache that PLT so that it has to generate as little of it as possible. Dialyzer stores the PLT in 2 parts, local and core. Local PLT is the cache for the app, and Core PLT is for the Elixir and Erlang libraries.

## Dialyxir is required

Dialyxir must be added to our deps in `mix.exs` if we haven't done so already.

```elixir
defp deps do
  [
    {:dialyxir, "~> 1.0", only: :test, runtime: false},
    ...
  ]
end
```

## Set the cache directory

We need to explicitly set the PLT paths in `mix.exs` so that they are within the project in a place that is easy to cache. Here I am setting them to both be saved in a folder called `dialyzer.`

```elixir
  def project do
    [
      ...
      dialyzer: [
        plt_local_path: "dialyzer",
        plt_core_path: "dialyzer"
      ],
  ...
  ]
  end
```

Now we need to create the directory and include a `.gitkeep.` The gitkeep file is necessary as a placeholder because otherwise, git will not preserve the directory. Git is aware of files but not directories, so to make a directory exist, it must have at least one file.

```bash
mkdir dialyzer
touch dialyzer/.gitkeep
```

Dialyzer will save the PLT files to that location when running `mix dialyzer`. We now need to instruct the CI provider on caching that directory

## Cache that directory on CI

Here is a minimum viable example from GitHub Actions that sets up Erlang and Elixir, fetches dependencies, runs Dialyzer, and caches the result.

```yaml
name: Dialyzer
on: [push, pull_request]

jobs:
  dialyzer:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: actions/cache@v2
        with:
          path: |
            deps
            _build
            dialyzer
          key: ${{ runner.os }}-dialyzer-${{ hashFiles('**/mix.lock') }}
          restore-keys: |
            ${{ runner.os }}-Dialyzer-
      - uses: erlef/setup-beam@v1
        with:
          otp-version: 25.0
          elixir-version: 1.13.4
      - run: mix deps.get
      - run: mix dialyzer
```

## In conclusion

Make sure to note the time it takes to run without caching, and then run a few times after adding caching and ensure that there is a difference. The decrease in runtime should be dramatic; if it isn't, the setup likely needs adjustments.
