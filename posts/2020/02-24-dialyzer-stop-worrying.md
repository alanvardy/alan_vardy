==title==
Dialyzer, or how I learned to stop worrying and love the cryptic error messages

==author==
Alan Vardy

==footer==


==description==
How to make Dialyzer work better for you

==tags==
elixir,dialyzer,ecto

==body==
# Dialyzer isn't universally loved

I like Dialyzer, it is a tool that provides a lot more benefit than cost (for me) and once in a while spits out some _really_ gnarly puzzles. There are however many people who struggle with it and I wrote this post to communicate how I think about Dialyzer and how I use it, I hope you get some value from it!

# Dialyzer checks your types

It looks at your functions and does its best to infer what types your functions take as arguments, and what the return value types are. It then looks at your typespecs (see below) and the specifications you wrote and what those arguments and return value types. Then, because it is feeling fresh and peppy, I repeats the process for all of your dependencies. All of this data is stored in the Persistent Lookup Table, or PLT.

And do you know what it does then? It compares all of those bits of information for inconsistencies.

... and if any of them conflict?

![alt text](nuclear_explosion.jpg "Nuclear Explosion")
(Cryptic error messages)

# Dialyzer is a gradual, optimistic type checker

Dialyzer can be introduced gradually into a code base, in fact the tool can be run without any defined typespecs at all and still be of use! This is possible because it is an optimistic type checker, it considers your code _"innocent until proven guilty"_. That means that it actually needs to find a conflict in type information, the absence of information is not enough. Some other type checkers require everything to be typed (the _"code is guilty until proven innocent"_ method). Both have their advantages and disadvantages, the trade-off that Dialyzer has adopted means that:

- Dialyzer won't catch all of your type errors, but ...
- When it does, **it is practically always right**.

# Dialyzer is an Erlang tool

Because Elixir is [warning massive oversimplification incoming] just Erlang with a bunch of delicious sprinkles on top, it compiles down to the same BEAM beam files and can be analyzed in the same manner. You can [read the docs here](http://erlang.org/doc/apps/dialyzer/dialyzer_chapter.html), but don't worry about the commands given, that comes later in this post.

# Why use Dialyzer

## Typespecs are a form of tests

They ensure that a developer working in a codebase cannot send the wrong type of argument to a function. They render whole classes of errors toothless, and help prevent regressions.

## Unlike documentation, they do not go out of date

If you update your function to take different arguments, and do not update your specs, you will inevitably get an error. This means that for anyone glancing over your code, typespecs are a very reliable source of information on what your function takes as arguments and returns.

## If you maintain good habits they are very easy to write

There are not that many types, so it is easy to hold the syntax in your head after a short time of writing them. And if your code base is already covered with specs, then you can be confident that any errors that occur are likely from the new code you just wrote.

# Use some basic tools to make it easier to run

## Use Dialyxir

[Add Dialyxir to your project](https://github.com/jeremyjh/dialyxir) to enable the `mix dialyzer` command, better error messages, better defaults etc. I consider this tool to be non-optional. 

## Install the Elixir LS fork

If you are using Visual Studio Code then install the [vscode-elixir-ls plugin](https://marketplace.visualstudio.com/items?itemName=elixir-lsp.elixir-ls), which can also be found [on GitHub](https://github.com/elixir-lsp/vscode-elixir-ls). Note that I am linking to the actively maintained fork, and not the original repository. The original author, Jake Becker, has been mysteriously absent and I wish him all the best - and thank him for his work. This plugin will work with dialyzer, credo, the formatter and other tooling to provide linting in your browser window and is a fantastic resource. 

## There are helpers you can use in IEx

use `i/1` and `t/1` to introspect your data

    iex> t Enum
    @type t() :: Enumerable.t()
    @type element() :: any()
    @type index() :: non_neg_integer()
    @type default() :: any()
    
Find out more in the [IEx.Helpers](https://hexdocs.pm/iex/IEx.Helpers.html) module

# Good habits

## Run Dialyzer all the time

This one is critical. Run it all the time. Make a two or three letter bash alias and run it with your tests. Errors are easy to solve when it is the last thing you just wrote.

## Never write typespecs on a project where Dialyzer isn't being run

This creates more problems than it solves. A bad typespec is worse than no typespec. The worst case is a library with bad typespecs, as this leaves the users of the library with a choice of whether they need to abandon their tooling or your library *(hint: they probably won't abandon their hard earned tooling)*

## Write your typespecs as you write your code

Don't put off all your specs until the MVP is done, it didn't work for your tests and it won't work for your specs either.

## Specify your Elixir version

credit to [Matt Reimer](https://github.com/matt-riemer)

Dialyzer greatly benefits from updates, so make sure that you are using the latest versions of Elixir and Erlang! I have had multiple occasions where strange errors disappeared simply by updating the version number.

Your `mix.exs` has by default:

```
elixir: "~> 1.5",
```

Which is just a crime. Update it and recompile.

Use asdf and a `.tool-versions` file, and specify your dependencies:

```
elixir 1.10.1
erlang 22.1.8
nodejs 12.6.0
```

# Writing typespecs

Typespecs are written using the `@spec` module attribute above a function, customarily above the function. Here is an example of a function that takes two integers and returns an integer:

    @spec add_things(integer, integer) :: integer
    def add_things(num1, num2), do: num1 + num2

Give the [typespec documentation](https://hexdocs.pm/elixir/typespecs.html) a read through!

Some tips:

- `type` is a build in Erlang type
- `t()` (As in `String.t()` or `Ecto.Schema.t()`) comes from Elixir
- `String.t()` and `binary` are the same thing.
- You can specify your own types with `@type`
- You can make unions with `|`
- Lists, maps, tuples can be expressed literally
- Try not to use any, it's lazy.
- If you are having trouble writing the typespec, there could be an issue with your function, not the spec.
- Add specs to your [Ecto Schemas](https://hexdocs.pm/ecto/Ecto.Schema.html)

      @type t :: %__MODULE__{
                id: non_neg_integer | nil,
                email: binary | nil,
                name: binary | nil,
                preference: Preference.t() | nil | Ecto.Association.NotLoaded.t()
              }
      
        schema "users" do
          field :email, :string
          field :name, :string
          has_one :preference, Preference
        end



# Interpreting errors

The most important clue: If you run Dialyzer frequently, then it is probably the last thing you wrote.

The second most important clue: It is likely the typespec you wrote, not the function.

## Function has no local return

This means that Dialyzer doesn't think that the function will succeed because of an issue that is often deeper in the stack. This doesn't necessarily mean that the issue is here, just that it will fail because of a mismatch. You should go look at the other error messages for more detail, and come back to this last if it is still there.

## [huge Erlang data structure] does not match [huge Erlang data structure]

This is a very common one where there is often one tiny little difference between the two that is not readily apparent. For this I open two panes of my favourite code editor side by side and paste one data structure into each pane. I then start eliminating the items that match until I find all the things that do not.

## The call module:function will never return since it differs from the success typing arguments

Very similar to the above, compare and eliminate.

## The call [function/num] will never return since it differs in the 2nd argument from the success typing arguments

There is something wrong with the second argument. It might be the function, it might be the typespec, or it could be one of the functions that calls it, *or that function's typespec*

## Invalid type specification for function module:function/1. The success typing is (boolean()) -> atom()

Same as above, should be straightforward.

## Overloaded contract for module:function/2 has overlapping domains; such contracts are currently unsupported and are simply ignored

You have two typespecs for the same function, I appreciate the enthusiasm but it really isn't needed :)

## Function function/2 will never be called

This one is really nice, Dialyzer found dead code! According to its analysis this code will never be run.

## The pattern some_pattern can never match since previous clauses completely covered the type some_type

This one is similar: one of the paths in your case statement can never be called. I do sometimes get false positives on this one as Dialyzer does not have a concept of environments. If I have a case statement that matches on which environment I am in, it thinks that said environment is the only one possible and will give this message for the other environments.

# In conclusion

Hopefully this sheds some light on a few of the techniques you can use to make Dialyzer work for you.

I recommend that you follow up with [this article from Learn You Some Erlang](https://learnyousomeerlang.com/dialyzer) if you are interested in discovering more, and let me know if I can do anything to make this article better!
