==title==
Simple belongs_to/has_many associations with Phoenix

==author==
Alan Vardy

==footer==


==description==
A simplistic introduction to associations with Ecto in Phoenix

==tags==
elixir,phoenix,ecto

==body==
Coming from a Rails background, there are a few _gotchas_ that I had to work through to make the magic happen. For this example I am using exercises and sets. Each set belongs to an exercise and each exercise has many sets. The app I created is called associations.

# Generate all the things

First comes the scaffolding (don't forget to add the routes and migrate) 

```bash
mix phx.gen.html Workouts Exercise exercises title:string
mix phx.gen.html Workouts Set sets reps:integer weight:float exercise_id:references:exercises
```

# Schema modifications

Your exercise.ex schema needs to have its has\_many added under schema.

```elixir
# exercise.ex
defmodule Associations.Workouts.Exercise do
. . .
  schema "exercises" do
    field :title, :string
    has_many :sets, Associations.Workouts.Set

    timestamps()
  end
. . .
end
```

And your set.ex needs the belongs\_to added to the schema and the exercise\_id added to the changeset. I find it interesting that I no longer need to specify the exercise_id field, it is inferred as part of the belongs\_to

```elixir
# set.ex

defmodule Associations.Workouts.Set do
  use Ecto.Schema
  import Ecto.Changeset

  schema "sets" do
    field :reps, :integer
    field :weight, :float
    belongs_to :exercise, Associations.Workouts.Exercise

    timestamps()
  end

  @doc false
  def changeset(set, attrs) do
    set
    |> cast(attrs, [:reps, :weight, :exercise_id])
    |> validate_required([:reps, :weight, :exercise_id])
  end
end
```

# Add exercise to set form

This is what your tag looks like, the @exercises is a map where each key is the title and value is the corresponding id.

```elixir
# set/form.html.eex

  <%= select f, :exercise_id, @exercises %>
  <%= error_tag f, :exercise_id %>
```

# Modify set controller

Your new and edit actions need to pass the exercises variable to your templates.

```elixir
#set_controller.ex

defmodule AssociationsWeb.SetController do
. . .
  def new(conn, _params) do
    exercises = Workouts.exercise_map
    changeset = Workouts.change_set(%Set{})
    render(conn, "new.html", changeset: changeset, exercises: exercises)
  end
. . .
  def edit(conn, %{"id" => id}) do
    set = Workouts.get_set!(id)
    exercises = Workouts.exercise_map
    changeset = Workouts.change_set(set)
    render(conn, "edit.html", set: set, changeset: changeset, exercises: exercises)
  end
. . .
end
```

# Workouts

Here you need to define your exercise_map function referenced earlier, and also preload the exercise in two others.

```elixir
# workouts.ex

defmodule Associations.Workouts do
. . .
  def exercise_map do
    list_exercises()
    |> Enum.map(fn x -> {x.title, x.id} end)
  end
. . .
  def list_sets do
    Set
    |> preload(:exercise)
    |> Repo.all()
  end
. . .
  def get_set!(id) do
    Set
    |> preload(:exercise)
    |> Repo.get!(id)
  end
. . .
end
```

# Use it in your views

Cool! Now you can display it. (This is clunky, but hey! I'm new!)

```elixir
  <%= if @set.exercise_id do %>
  <li>
    <strong>Exercise:</strong>
    <%= @set.exercise.title %>
  </li>
  <% end %>
```
