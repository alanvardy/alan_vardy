==title==
TIL: When to use the partitioning key in indexes on partitioned tables

==author==
Alan Vardy

==footer==

==description==
When to use or not use the partitioning key in indexes on partitioned tables

==tags==
postgres

==body==

**TLDR; For partitioned tables, only use the partitioning key in unique indexes.**

Imagine that we have a `users` table partitioned by country, and wish to create a couple of indexes.

```sql
CREATE TABLE users ( 
    country         text not null,
    age             int not null,
    name            text not null
) PARTITION BY LIST (country);
```

If we want to create a new index to ensure that we do not have duplicate names per country, we would need to include the country in the unique index. We cannot create an index with just the name because then we cannot guarantee uniqueness across partitions... we can only do so by partition.

```sql
CREATE UNIQUE INDEX unique_country_name_idx ON users (country, name)
```

But if we want to put an index on age (so we can query all the people in a country who are older than 16 for example), we do not want to use the partitioning column.

```sql
CREATE INDEX age_idx ON users (age)
```

This works because if you query for all users in the `United States` that are 7 or below, Postgres will first find the partition for the `United States` and then use the index within only that partition.

If you add the `country` column to the non-unique index it will be counter-productive because it enlarges the index and makes it less likely that the query planner will use it as it prefers smaller indexes to larger ones. Once an index is determined to be not specific enough to a use case it will often just fall back to a sequential scan, aka just reading the whole table.
