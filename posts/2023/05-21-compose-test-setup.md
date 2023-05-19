==title==
Compose your Elixir test setup

==author==
Alan Vardy

==footer==

==description==
How to make test setup more maintainable, readable, and reusable with composition.

==tags==
tests,elixir

==body==

![Test Tubes](testtubes.jpg "Test tubes")
[From Unsplash](https://unsplash.com/photos/pgfWIStWIfs)

## Test setup should be damp, not wet

When writing acceptance tests (as opposed to unit tests), we often need to set up the "state" of the application by doing things like inserted database records, putting values in caches, and mocking API calls. This code can be laborious to write, and we soon find ourselves copying and pasting test cases in order to use the same setup again and again. This results in rather WET code (We Enjoy Typing). In order to DRY (Don't Repeat Yourself) out the code a little we can abstract out the setup into imported functions that are easy to read and reason about.

## Tests should help you make changes, not hold you back

Abstracting out test setup is a big benefit when writing out new test cases, but the even larger benefit is the ease in making changes to a large test suite. When the setup for inserting a new user is in one place, and is used by 1000 test cases, a change to the user schema that breaks all 1000 tests can be resolved by fixing that one test setup.  

## An example

For this case we are writing a test that requires a post, and the post requires a user to be associated with it. So we can compose two functions together like so.

```elixir
defmodule MyApp.PostTest do
  setup [:user, :post]

  test "can add a comment", %{user: user, post: post} do
    assert :ok = Post.add_comment(user, post)
  end

  # Setup functions take a map of the context
  # And the map they return is merged into that context
  defp user(_) do
    %{user: Factory.insert_user()}
  end

  defp post(%{user: user}) do
    post = Factory.insert_post(%{user_id: user.id})
  end
end
```

This removes the implementation details from the test case, but doesn't hide it from the reader. Another test case can add or remove components as well.

```elixir
defmodule MyApp.PostTest do

...

describe "subscribers" do
  setup [:user, :post, :subscriber, :comment]

  test "subscriber can view comments" do
    ...    
  end

  ...
end
```

We will soon find that we need to share common test setup across multiple test files, and for this common test setup modules are useful. 

```elixir
defmodule MyApp.Support.TestSetup do
  @doc "Insert a new user"
  def user(_) do
    %{user: Factory.insert_user()}
  end

  @doc "Insert a new post"
  def post(%{user: user}) do
    post = Factory.insert_post(%{user_id: user.id})
  end
end
```

When adding a `support` folder to your test directory for the first time you may need to add it to the compiler paths in your `mix.exs` file.

```elixir
defmodule MyApp.MixProject do
  use Mix.Project

  def project do
    [
      ...
      
      elixirc_paths: elixirc_paths(Mix.env()),

      ...
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]
end
```

And then the functions can then be explicitly imported into the test file. Some would use macros to bring in these test setup functions much like how Phoenix does, but the issue with that is that while many Elixir developers are familiar with Phoenix and can handle that implicit overhead it is not great to force other developers to hunt for additional hidden imports.

```elixir
defmodule MyApp.PostTest do
  import MyApp.Support.TestSetup, only [user: 1, post: 1]

  setup [:user, :post]

  test "can add a comment", %{user: user, post: post} do
    assert :ok = Post.add_comment(user, post)
  end
end
```

## Stack them like Lego

By keeping these setup functions small, composable and explicit like little toy blocks it will be much easier to write new tests and maintain old ones as codebases grow and change.