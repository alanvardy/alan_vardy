==title==
Using pg_stat_statements to find slow Postgres queries

==author==
Alan Vardy

==footer==

==description==
Find slow queries using a built-in Postgres view.

==tags==
postgres

==body==

![An elephant doing elephant things](elephant.jpg "An elephant doing elephant things")
[From Unsplash](https://unsplash.com/photos/OP3ghv27Yto)

## Why do we need pg_stat_statements

Slow queries can be one of the worst things to happen to a web application because databases are often the primary source of shared state. Long-running Postgres operations will monopolize connections and tie up the database CPU as it struggles to complete the query. In addition, other queries that would typically not experience issues fail to execute, and the knock-on effect can bring down the whole system.

To determine which queries are slower than others and identify potential problems, we can use a view in Postgres called `pg_stat_statements`. This view is an aggregate of statistics around the queries (and mutations) and helps us identify how much stress these operations put on the database.

I recommend periodically checking the `pg_stat_statements` view for slow queries to catch them before they become a problem, and it is also a way to find them in a hurry. We may even find that optimizing queries can reduce the costs of running the database as fewer resources may need to be assigned to it afterward, or it may not need to have more resources allocated in the future. The database can be the part of the system that is most expensive to scale; thus, this effort is frequently worth it.

Resolving these slow queries generally involves adding an index or rewriting some SQL, but those next steps are to be covered in a later post.

## It needs to be enabled

Postgres includes `pg_stat_statements` as an extension but does not have the functionality enabled by default. If you are working on a team, `pg_stat_statements` are likely already enabled. If you are working independently, you will have to do that yourself.

You can find out more in the [Official Postgres docs](https://www.postgresql.org/docs/current/pgstatstatements.html)

## Clear the view before querying

If we want to use the `pg_stat_statements` view, it is a good idea to clear it first so that all the statistics we see are up to date. If we don't clear it, we will see all the stats back to the last time someone cleared it, including issues we have already fixed.

Run the following in your Postgres client to clear the view:

```sql
  SELECT pg_stat_statements_reset();  
```

You can also query `pg_stat_statements_info` to find out when someone last cleared the `pg_stat_statements` view.

```sql
  SELECT stats_reset from pg_stat_statments_info
```

## Look for queries that are slow on average

Ordering queries by the mean is the most common way of searching for slow queries.

The following query finds the 20 worst offenders by mean and eliminates any with less than 100 calls so that we can ignore red herrings that only ran once or twice.

```sql
SELECT query, calls, mean_exec_time AS mean, stddev_exec_time AS standard_deviation, max_exec_time AS max
FROM pg_stat_statements
WHERE calls > 100
ORDER BY mean DESC
LIMIT 20;
```

This will output a table like

```sql
+--------------------+------+-----------------+------------------+-----------+
|query               |calls |mean             |standard_deviation|max        |
+--------------------+------+-----------------+------------------+-----------+
|SELECT * FROM users | 136  |304.6795694191177|5.989337779152523 |322.665935 |
| another query      | 2323 |183.8253951244082|162.2536940658891 |2125.271036|
| yet another query  | 4191 |66.04167927869267|127.54380348573054|3886.514188|
+--------------------+------+-----------------+------------------+-----------+
```

Here we can see each query and the average that it took to run in milliseconds, along with the standard deviation and max. Postgres versions before 13 will have slightly different column names, such as `mean_time` instead of `mean_exec_time`.

## Find queries that are not hitting the Postgres ram cache

I sourced the next query from [this excellent Timescale post](https://www.timescale.com/blog/identify-postgresql-performance-bottlenecks-with-pg_stat_statements/)

Here we can find queries that are not hitting ram. A `hit_cache_ratio` of below 98% is worth further investigation. Too much data or insufficient ram will force Postgres to go to the much slower hard drive. The solution will likely be better indexes or more ram for the machine hosting your database.

```sql
SELECT calls,
 shared_blks_hit,
 shared_blks_read,
 shared_blks_hit/(shared_blks_hit+shared_blks_read)::NUMERIC*100 hit_cache_ratio,
 query
FROM pg_stat_statements
WHERE calls > 500
AND shared_blks_hit > 0
ORDER BY calls DESC, hit_cache_ratio ASC
LIMIT 20;
```

Resulting in a table such as

```sql
+---------+---------------+----------------+---------------------+--------------------+
|calls    |shared_blks_hit|shared_blks_read|hit_cache_ratio      |query               |
+---------+---------------+----------------+---------------------+--------------------+
|340466515|340466515      |0               |100                  |SELECT * FROM USERS |
|66946011 |2997500599     |23335613        |99.227511478202579227|other query         |
+---------+---------------+----------------+---------------------+--------------------+
```

## Use queryid to differentiate queries

The `query` column is ideal for determining which query in your application code is problematic, but if you want to identify and compare specific queries with each other on the `pg_stat_statements` table, use the `queryid` column instead. The `queryid` is the calculated value that Postgres uses to combine similar queries.

## Conclusion

`pg_stat_statements` is a valuable tool for finding troublesome queries that degrade database performance and increase costs, use it to determine your next steps when troubleshooting issues in production.
