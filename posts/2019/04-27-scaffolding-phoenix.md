==title==
Scaffolding with Phoenix

==author==
Alan Vardy

==footer==


==description==
Create a ton of files with a single command

==tags==
elixir,phoenix,ecto

==body==
I love scaffolding, probably more than I should! It gets me playing with data right away and lets me put up a skeleton quickly. The nice thing about scaffolding with Phoenix (compared to Rails) is that less "cruft" is created. No extra css, coffee script, or fixtures created. Yay!

The special command for scaffolding is:

```bash
mix phx.gen.html Accounts User users name:string age:integer
```

in order:

- `mix` is the sweet tool for running all your tasks
- `phx.gen.html` is the namespaced module containing the generation code
- `Accounts` is your context, the "group" or "collection" it belongs to.
- `User` is the name of the module that contains your schema and changeset
- `users` is the name of your database table
- and the remainder are your attributes.

The following attributes are avaliable:

- `:integer`
- `:float`
- `:decimal`
- `:boolean`
- `:map`
- `:string`
- `:array`
- `:references`
- `:text`
- `:date`
- `:time`
- `:time_usec`
- `:naive_datetime`
- `:naive_datetime_usec`
- `:utc_datetime`
- `:utc_datetime_usec`
- `:uuid`
- `:binary`
- `:datetime` - An alias for `:naive_datetime`

I find the `references` option to be interesting, used like:

```bash
user_id:references:users
```

Oh? You just want to generate the context and not the html? Then use this command:

```bash
mix phx.gen.schema Accounts.User users name:string age:integer
```
