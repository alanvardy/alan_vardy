==title==
Elixir and Phoenix Commands for a Rails Developer

==author==
Alan Vardy

==footer==


==description==
A quick list of useful commands for a developer coming from Rails

==tags==
elixir, phoenix

==body==
## New Mix Project

```bash
mix new project_name
```

## New Phoenix Project

```bash
mix phx.new project_name
```

## Install dependencies

(aka `bundle`)

```bash
mix depts.get
```

## Hex will not install with 

`mix deps.get` throwing an error after a timeout

```bash
HEX_HTTP_CONCURRENCY=1 HEX_HTTP_TIMEOUT=120 mix deps.get
```

## Console

(aka `irb`)

```bash
iex -S mix
```

## Phoenix console

(aka `rails console`)

```bash
iex -S mix phx.server
```

## Reload console

(aka `reload!`)

```bash
recompile
```

## Scaffold resources

Example of videos with multimedia context

```bash
mix phx.gen.html Multimedia Video videos user_id:references:users url:string title:string description:text
```

## Generate docs

Add dependency to mix.exs within the `deps` code block

```elixir
{:ex_doc, "~> 0.20"}
```

Install dependencies

```bash
mix deps.get
```

Generate docs

```bash
mix docs
```
