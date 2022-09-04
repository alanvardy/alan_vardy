==title==
Profile slow code with eprof

==author==
Alan Vardy

==footer==

==description==
How to find bottlenecks in your Elixir code using Erlang tools

==tags==
profiling,erlang,elixir

==body==
So you have some Elixir code and you think it is slow, and you want to know why!

There are a number of tools available to us out of the box with Erlang, and my favourite one for profiling functions is called `eprof`. `eprof` is a quick way to get a sense of which functions are called, how often, and how long they took to run. It outputs the results to the terminal (and optionally to a file) in a reasonably easy to read format.

Bear in mind that there is a runtime cost to using `eprof` so if you can run it locally before attempting it in production I would recommend doing so.

Oh, and if an Ecto query is part of your code then make sure to check your `pg_stat_statements` as well.

# Using eprof

In the most simple example, we need to

## 1. Start eprof

```elixir
:eprof.start()
```

Which returns `{:ok, pid}`

## 2. Profile the function

Wrap it in a 0 arity anonymous function

```elixir
:eprof.profile(fn -> SomeModule.example_function() end)
```

This returns the value of the contained function

## 3. Output analysis on that function

```elixir
:eprof.analyze()
```

And the output will resemble this:

```elixir
****** Process <0.610.0>    -- 100.00 % of profiled time *** 
FUNCTION                                                       CALLS        %  TIME  [uS / CALLS]
-------- 

... a bunch of extra lines ...      
                                                               -----  -------  ----  [----------]
'Elixir.Plug.Adapters.Test.Conn':conn/4                            1     1.43     5  [      5.00]
'Elixir.String.Chars':to_string/1                                 14     1.43     5  [      0.36]
'Elixir.Keyword':pop/3                                            12     1.72     6  [      0.50]
'Elixir.Phoenix.HTML.Tag':sorted_attrs/1                          13     1.72     6  [      0.46]
erl_eval:expr/5                                                    7     2.01     7  [      1.00]
'Elixir.Keyword':get/3                                            15     2.01     7  [      0.47]
'Elixir.URI':'-encode/2-lbc$^0/2-0-'/3                            12     2.01     7  [      0.58]
'Elixir.String':replace_guarded/4                                  6     2.01     7  [      1.17]
error_handler:undefined_function/3                                 8     2.29     8  [      1.00]
'Elixir.Phoenix.HTML.Tag':content_tag/3                           13     2.29     8  [      0.62]
'Elixir.Phoenix.HTML':build_attrs/1                               30     2.58     9  [      0.30]
erlang:monitor/2                                                   8     2.87    10  [      1.25]
erlang:demonitor/2                                                 8     3.72    13  [      1.63]
code_server:call/1                                                 8     5.16    18  [      2.25]
re:run/3                                                           1     7.16    25  [     25.00]
'Elixir.Phoenix.HTML.Engine':html_escape/5                       293     9.17    32  [      0.11]
-------------------------------------------------------------  -----  -------  ----  [----------]
Total:                                                          1156  100.00%   349  [      0.30]
```

Shown in the columns is, in order:

- The function called
- The number of times it was called
- The percentage of the total time those functions spent running
- The total time those functions spent running
- The time per call they spent running

## 4. And then finally stop profiling

Make sure not to skip this step, otherwise you may end up with a dangling process.

```elixir
:eprof.stop()
```

Returns `:stopped`

# Additional information

## 1. You can save the results to a log file

Run this before `analyze/0`

```elixir
:eprof.log("results")
```

## 2. There is a more powerful version called fprof

[fprof](https://www.erlang.org/docs/24/man/fprof.html) is also more difficult to interpret, but could help if you are debugging more sophisticated issues i.e. concurrent processes.

### 3. There are other tools that generate flamegraphs

If you are looking for a flamegraph then [eFlambe](https://github.com/Stratus3D/eflambe) may interest you.
