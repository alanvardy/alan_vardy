==title==
Testing Async Processes in Elixir

==author==
Alan Vardy

==footer==

==description==
Improve the testing of async processes such as GenServers, Tasks, and GenStage pipelines.

==tags==
elixir,testing

==body==
Testing async processes in Elixir can be complex, especially around database calls and timing issues. However, there are a few principles that can make it easier to write dependable and fast tests.

![A bunch of pipes](pipes.jpg "A bunch of pipes")

## Start processes in the test case

While we usually want to start our processes in the `Application` module, in the test environment, it is beneficial to start processes manually with `start_supervised!/2` in the test case setup. This allows us to have control over when a process starts and what state it starts with.

You can make the starting of a process conditional by wrapping it in an environment check that is evaluated at compile time.

```elixir
# MyApp.Application

def start(_type, _args) do
    children = [MyApp.Endpoint] ++ processes()

    opts = [strategy: :one_for_one, name: MyApp.Supervisor]
    Supervisor.start_link(children, opts)
  end

if Mix.env() === :test do
  def processes, do: []
else
  def processes, do: [{SomeProcess, self()}]
end
```

and then start the process in your test case. The `self/0` function obtains the PID of the current process.

```elixir
# In your test file i.e. MyApp.SomeProcessTest

setup do
  start_supervised!({SomeProcess, self()})
end
```

[Read more about start_supervised/2](https://hexdocs.pm/ex_unit/ExUnit.Callbacks.html#start_supervised!/2)

## Pass in the caller to fix Ecto sandbox issues

Database operations generally run within a transaction in the test environment, so any changes made to the database during the test can be rolled back by Postgres at the end. By default, Ecto checks out one transaction per test case and links it to the PID of the test. This is called `manual` mode and is used when the `use DataCase` macro is set to `async: true`. The alternative mode is `shared` and is used when the macro is set to `async: false` or just omitted entirely. In shared mode all processes running simultaneously share the same transaction. Shared mode and synchronous tests go together because async tests need individual transactions to make sure that they are not sharing state. We want test transactions to be separate.

When running an async process in manual mode, any database calls it makes will error because there was no transaction taken out for that PID (only for the central test process). It would be easy to set `async: false` on the `use DataCase` macro to resolve the issue, but the trouble with setting these tests to synchronous is that it dramatically slows down the runtime of the test suite, and we just need to come back and fix it later anyways.

The solution is to use the `caller` option of Repo. If we pass in the PID of the main test process it will use that PID when finding the transaction rather than its own.

```elixir
# In your production code i.e. MyApp.Accounts

def all_users(caller \\ self())
  MyApp.Repo.all(from(u in User), caller: caller)
end
```

When starting up the async process in `start_supervised!/2`, pass in the PID of the test process and use that for all repo calls. Application code that does not run in other async processes can omit the argument. You can see an example of this in the last section.

[Read more about Ecto Sandbox](https://hexdocs.pm/ecto_sql/Ecto.Adapters.SQL.Sandbox.html)

## Send messages to synchronize

When it takes time for an async process to finish its job, we have to wait for it to complete before asserting the result. The first instinct could be to use `Process.sleep/1` and then assert after that delay. Sleeping can work but also leaves us with slow tests (because they will generally be waiting longer than necessary) and flaky tests (sometimes they won't wait long enough). This difference in run speed is exacerbated by the difference in performance between a developer's machine and the container running the test on a continuous integration service. A better solution is sending a message from the async process to the test process to let it know it is ready for the assertion.

Create a function that only sends messages in the test environment and store it in a helpers file

```elixir
  # Put this in a helpers file such as MyApp.Helpers

  @doc """
  Provides a synchronization point for testing GenServers.
  Sends a message in test and noops in other environments

  assert_receive(:sync, 500) in test file
  """
  if Mix.env() === :test do
    def maybe_send_sync(pid), do: send(pid, :sync)
  else
    def maybe_send_sync(_pid), do: :sync
  end
```

As long as the async process has the PID of the test process (see previous examples), it can communicate back to say that it is done.

[Read more about assert_recieve/3](https://hexdocs.pm/ex_unit/ExUnit.Assertions.html#assert_receive/3)

## Conclusion

These three techniques are a few of many that can improve the reliability and performance of our test suite when testing async processes. We should strive to not set `async: false`, but instead take the extra steps to ensure that our async tests run as well as the others.
