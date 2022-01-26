==title==
Unit Testing GraphQL Queries

==author==
Alan Vardy

==footer==


==description==
A quick example for testing your GraphQL queries

==tags==
elixir,phoenix,absinthe,graphql,testing

==body==

I am taking the [Learn-Elixir.dev](https://learn-elixir.dev/home) course right now to fill in some knowledge gaps, including [GraphQL](https://graphql.org/)

For the purposes of this post I am not describing how to create the functionality in Absinthe, just how to test it. It is a simple resource called `user`. Inventive, right?

# Create your test module

I chose to namespace my tests under `Schema.Queries.UserTest` but you may wish to be a bit less verbose.

```
defmodule YourAppWeb.Schema.Queries.UserTest do
  use YourApp.DataCase, async: true
  alias YourApp.Accounts # The context for your users
  alias YourAppWeb.Schema # Your Absinthe schema
  
  # Test code goes here
  
end
```

# Define your resource

The resource we are testing today is a user. The user has a name, an email address, and an age. Don't question why we are storing an age, it isn't supposed to make sense :)

I am adding these params as a module attribute to reuse between tests, nothing crazy so far and this will likely be familiar to you if you have written Ecto tests with ExUnit before.

```
@user_params %{name: "Nancy", email: "nancybell@email.com", age: 53}
```

# Define your GraphQL doc

This is where things get a bit different! This doc defines your argument types with:

 `findUser($name: String, $email: String, $age: Int)` ([learn more about GraphQL types](https://graphql.org/learn/schema/#the-query-and-mutation-types))
 
 Something interesting is that it does not matter what is used for `findUser` because it is simple defining a new query, it can be `getUser`, `fetchUser` or `starshipsWereMeantToFly` for all that your code cares.
 
 and then the query type arguments themselves:
 
 `user(name: $name, email: $email, age: $age)`
 
 user references your actual GraphQL query name (so it matters), and the arguments that you are available.
 
 and finally the return variables
 
 `{id, name, email, age}`
 
 They all combine to form:
 

```
@user_doc """
  query someUser($name: String, $email: String, $age: Int) {
    user(name: $name, email: $email) {
      id,
      name,
      email
    }
  }
"""
```

# Create your user

Just like Ecto, use your context to create a user with the params defined earlier, and pattern match to grab the created user for later.

```
assert {:ok, user} = Accounts.create_user(@user_params)
```

# Run your Absinthe query

Use `Absinthe.run` with the document, schema and arguments to run a search. We pass in the arguments with a map, where the key is the variable placeholder in the user_doc. We also pattern match the response to get the data value.

```
assert {:ok, %{data: data}} = Absinthe.run(@user_doc, Schema, variables: %{"name" => "Nancy"})
```

# Assert that your Absinthe data matches the created user

Because it would be a terrible API if it returned something else right?

```
user_id =
  data
  |> get_in(["user", "id"])
  |> String.to_integer()

assert user_id === user.id
```

# Put it all together

Because you are probably sick of being spoonfed, here is the whole thing!

```elixir
defmodule YourAppWeb.Schema.Queries.UserTest do
  use YourApp.DataCase, async: true
  alias YourApp.Accounts
  alias YourAppWeb.Schema

  @user_doc """
    query findUser($name: String, $email: String) {
      user(name: $name, email: $email) {
        id,
        name,
        email
      }
    }
  """

  @user_params %{
    name: "Nancy",
    email: "nancybell@email.com",
    age: 53
  }

  describe "@user" do
    test "Can get the user by name" do
      assert {:ok, user} = Accounts.create_user(@user_params)

      assert {:ok, %{data: data}} =
               Absinthe.run(@user_doc, Schema, variables: %{"name" => "Nancy"})

      user_id =
        data
        |> get_in(["user", "id"])
        |> String.to_integer()

      assert user_id === user.id
    end
  end
end

```
