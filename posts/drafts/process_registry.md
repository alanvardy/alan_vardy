```
{Registry, keys: :unique, name: Dash.ProcessRegistry}
```

```
defp find_or_create_server(user_id) do
  server_name = "server-github-#{user_id}"

  case Registry.lookup(ProcessRegistry, server_name) do
    # Server does not exist for user
    [] ->
      name = {:via, Registry, {ProcessRegistry, server_name, :hello}}
      {:ok, pid} = GenServer.start_link(__MODULE__, %{user_id: user_id}, name: name)
      pid

    # Server does exist and its pid is returned
    server_list ->
      server_list |> List.first() |> elem(0)
  end
end
  ```

```
  def init(%{user_id: user_id}) do
    case get_user(user_id) do
      {:ok, user} ->
        Requester.start_link(self(), user)
        {:ok, %{reports: nil}}

      {:error, :not_found} ->
        {:stop, "User does not exist"}
    end
  end
  ```


https://hexdocs.pm/elixir/Registry.html
