==title==
Use Postgres for your development database

==author==
Alan Vardy

==footer==


==description==
Instructions on how to switch a development enviroment from sqlite3 to Postgres

==tags==
ruby,rails,postgres

==body==
So it has finally happened. You are tired of looking at your development server and its complete lack of database content. You want to import your production Postgres server's content, but SQLite3 and Postgres don't play nicely together do they?

You now want to run Postgres for development.

# Postgres

Install Postgres and add user (use the same one as your login)

```bash
sudo apt update
sudo apt install postgresql postgresql-contrib libpq-dev
sudo -u postgres createuser -s YOURUSERNAME
```

# Rails

Set your development in database.yml

```yaml
development:
  adapter: postgresql
  encoding: unicode
  database: yourdatabasename
  pool: 5
  username: YOURUSERNAME
  password:
```

And create the database (don't migrate, that information will come from the dump file)

```bash
rails db:drop
rails db:create
```

make sure that `gem 'pg'` is in the main section of your Gemfile and run

```bash
bundle install
```

# Restore

If your production database isn't full of sensitive information (mine for example is this blog), you can restore your production database into your development database. Backup your production database [using my handy script](https://github.com/alanvardy/dbbackup) and restore it to your development database.

```bash
pg_restore -c -U USERNAME -d DBNAME /PATH/TO/FILE.dump
```

If you already have a development database, delete it first 

```bash
rails db:drop
```

You will need to make sure that your development database on your machine has the same name as your production database on the remote server, as the backup will copy over the name of the database as well. This can be specified in your config/database.yml file.
