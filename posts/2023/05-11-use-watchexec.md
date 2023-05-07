==title==
Use watchexec to automatically run your Elixir code checks

==author==
Alan Vardy

==footer==

==description==
How to trigger tests and other checks when a change happens in your project

==tags==
cli,tests,elixir

==body==

![Gears](gears.jpg "Gears")
[From Unsplash](https://unsplash.com/photos/w95Fb7EEcjE)

## What is it

[watchexec](https://github.com/watchexec/watchexec) is a command line tool that executes commands whenever changes happen in a given directory.

## Why use it

It's pretty common to bounce between making small code changes and running `mix test`, instead of manually toggling between two windows our workflow can be dramatically increased by just having the tests run again every time a file is saved.

## A simple example

Run `mix test` every time a file with an extension `ex` or `exs` is modified.

```bash
watchexec -e ex,exs "mix test"
```

## Lint with Credo as well

We can take it a step further and only run the tests if [Credo static analysis](https://github.com/rrrene/credo) has passed.

```bash
watchexec -e ex,exs "mix credo && mix test"
```

## Show failing tests one at a time

If we have a lot of failing tests we can run them one at a time. Setting the seed manually ensures that they are run in the same order with the same parameters - this is helpful when debugging!

```bash
watchexec -e ex,exs "mix test --failed --seed 9 --max-failures 1 && mix test --max-failures 1 --seed 9"
```

## We are limited only by imagination

If we are using a large monitor it's relatively easy to set up a couple of different terminals automatically running our tests for us on every iteration and allowing us to keep our cursors in the code where they belong.
