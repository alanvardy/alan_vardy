==title==
Deploy a Phoenix app with Dokku and Digital Ocean

==author==
Alan Vardy

==footer==


==description==
Step by step instructions for deploying a Phoenix app to production

==tags==
digital ocean, dokku, elixir, phoenix, postgres

==body==
Credit to [Jon Lunsford](https://medium.com/@jonlunsford/elixir-up-and-running-with-dokku-on-digital-ocean-ce332d64224c)

# Buy a domain name

I use [Namecheap](https://www.namecheap.com/) and have been happy with them, I don't know if they are the best but they are certainly not the worst and I have had no issues with them. Just stay away from GoDaddy.

# Point your Domain name at Digital Ocean's DNS

We are doing this now because it can take a while for the settings to distribute across the web. In Namecheap I selected "Custom DNS" under Nameservers and put in Digital Ocean's 3 name servers:

- ns1.digitalocean.com
- ns2.digitalocean.com
- ns3.digitalocean.com

I really like how creative they were with the names.

# Sign up for Digital Ocean

[Sign up for Digital Ocean using this link](https://m.do.co/c/f50e5f739663) to get $100 in free credits over 60 days. Full disclosure: Once you spend $25 on their service I will get a $25 credit on my service. And I like free credits. I'd also be really happy that someone read this post. So please use the link!

# Create a Droplet

You can create a droplet (read: virtual private server) with Dokku pre-installed! When creating a droplet choose Dokku under the One-Click-Apps tab, [add your SSH keys](https://timleland.com/copy-ssh-key-to-clipboard/) and boot that puppy up.

# Finish Dokku Setup

Do this right away, if someone else beats you to it then they will have access to your server instead of you.

Navigate to your server's IP address (listed in Digital Ocean) and finish the setup on the admin page that appears. You will have to paste in your public ssh key again and I recommend using virtual host naming for your apps. It means that if you create an app called myapp, it will be accessible at myapp.mydomain.com

# Update your server

Trust me. I spent an hour troubleshooting a new server because I forget this step!

```bash
sudo apt update
sudo apt upgrade
```

# Create an app on your server

SSH onto your server

```bash
ssh root@your.droplet.ip.address
```

Create an app

```bash
dokku apps:create awesomeapp
```

Install Postgres, create and link database

```bash
dokku plugin:install https://github.com/dokku/dokku-postgres.git
dokku postgres:create awesomeappdb
dokku postgres:link awesomeappdb awesomeapp
```

Create a [swap file](https://help.ubuntu.com/community/SwapFaq) to help out on the ram front. You will only see output after the 3rd line.

```bash
fallocate -l 2G /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
```

Open fstab with Nano

```bash
nano /etc/fstab
```

Add this line at the bottom

```bash
/swapfile none swap sw 0 0
```

And then use CTRL+x, y, and then enter to save and exit.

# Change file upload limit from 1mb to 50mb

Add to /etc/nginx/conf.d/dokku.conf

```
client_max_body_size 50m;
```

and then reload nginx

```
nginx -s reload
```

# Configure Digital Ocean's DNS

Add the domain that you purchased on namecheap and you should see 3 entries pointing at each of Digital Ocean's cleverly named servers.

Now you need to create 'A' records for your domains. I created the following:

| Type | Hostname                | Value                |
| ---- | ----------------------- | -------------------- |
| A    | mydomain.com            | (select your server) |
| A    | www.mydomain.com        | (select your server) |
| A    | awesomeapp.mydomain.com | (select your server) |

etc.

# Install dokku-cli

[dokku-cli](https://github.com/SebastianSzturo/dokku-cli) is very similar to the Heroku command line tool and is a joy to use. No configuration is needed! Just run in your project directory and use 'dokku' in the place of 'heroku'.

Install Dokku CLI

```bash
gem install dokku-cli
```

# Make a new Phoenix App

```bash
mix phx.new awesomeapp
cd awesomeapp
mix deps.get
```

# Configure your Phoenix Endpoint

```elixir
# config/prod.exs

config :live_view_counter, LiveViewCounterWeb.Endpoint,
  http: [:inet6, port: System.get_env("PORT")],
  url: [host: System.get_env("WEB_HOST"), port: 5000],
  load_from_system_env: true,
  cache_static_manifest: "priv/static/cache_manifest.json"
```

# Configure Secrets

Configure `config/prod.secret.exs` to use env variables, this way we can safely check the file into source control

```elixir
# config/prod.secret.exs

use Mix.Config

# In this file, we keep production configuration that
# you'll likely want to automate and keep away from
# your version control system.
#
# You should document the content of this
# file or create a script for recreating it, since it's
# kept out of version control and might be hard to recover
# or recreate for your teammates (or yourself later on).
config :live_view_todos, LiveViewTodosWeb.Endpoint,
  secret_key_base: System.get_env("SECRET_KEY_BASE")

# Configure your database
config :live_view_todos, LiveViewTodos.Repo,
  username: "postgres",
  password: "postgres",
  database: "awesomeapdb",
  url: System.get_env("DATABASE_URL"),
  pool_size: 15
```

# Remove secrets from .gitignore

Comment out the following line in .`gitignore` so we can include it in git

```elixir
# .gitignore

# Alternatively, you may comment the line below and commit the
# secrets files as long as you replace their contents by environment
# variables.
# /config/*.secret.exs
```

# Create a Procfile

This goes in your root directory, telling Dokku how to start your server

```bash
# Procfile

web: ./.platform_tools/elixir/bin/mix phx.server
```

# Create a buildpacks file

This goes in your root directory, telling Dokku which packs to use

```bash
# .buildpacks (DON'T LEAVE THIS COMMENT IN YOUR FILE)

https://github.com/hashnuke/heroku-buildpack-elixir
https://github.com/gjaldon/heroku-buildpack-phoenix-static
```

# Create elixir\_buildpack.config

This goes in your root directory, telling Dokku which Elixir and Erlang versions to use. These are the latest versions as of this writing.

```bash
# elixir_buildpack.config

# Erlang version
erlang_version=21.3.7
# Elixir version
elixir_version=1.8.2
```

# Create a phoenix\_static\_buildpack.config file

This goes in your root directory, more information [here](https://github.com/gjaldon/heroku-buildpack-phoenix-static#configuration)

```bash
# phoenix_static_buildpack.config

# Use phoenix 1.3 executable
phoenix_ex=phx
```

# Automatic Migrations
This one just runs `mix ecto.migrate` automatically.

Create `app.json` in the root directory of your app

```json
{
  "name": "awesomeapp",
  "description": "My awesome Phoenix app, running on Dokku!",
  "keywords": [
    "dokku",
    "elixir",
    "phoenix"
  ],
  "scripts": {
    "dokku": {
      "postdeploy": "mix ecto.migrate"
    }
  }
}
```

# Add remote repository

Navigate to your awesomeapp project directory, initialize git and add the repository

```bash
git init
git add .
git commit -m 'new phoenix app'
git remote add dokku dokku@your.droplet.ip.address:awesomeapp
```

# Set your environment variables

```bash
dokku config:set MIX_ENV="prod" PORT=5000 SECRET_KEY_BASE="`mix phx.gen.secret`" WEB_HOST="awesomeapp.yourdomain.com"
```

# Push your code

```bash
git push dokku master
```

# Migration

Migrate your database

```bash
dokku run mix ecto.migrate
```

# Free SSL with Let's Encrypt

[Let's Encrypt](https://letsencrypt.org/) provides free SSL certificates. You can find more complete instructions and explanations [here](https://medium.com/@pimterry/effortlessly-add-https-to-dokku-with-lets-encrypt-900696366890).

SSH onto your server

```bash
ssh root@your.droplet.ip.address
```

Install Let's Encrypt

```bash
dokku plugin:install https://github.com/dokku/dokku-letsencrypt.git
```

Update if it was already installed

```bash
dokku plugin:update letsencrypt
```

Set your email address (note that you need to change MYAPP and ME@MYEMAIL.COM)

```bash
dokku config:set --no-restart awesomeapp DOKKU_LETSENCRYPT_EMAIL=ME@MYEMAIL.COM
```

Turn it on

```bash
dokku letsencrypt awesomeapp
```

Set up auto-renewal with a cronjob

```bash
dokku letsencrypt:cron-job --add
```

# Backup your databases

I wrote a shell script for this very issue. It downloads all your Postgres databases from Heroku and Dokku and uploads them (conveiently dated) to Google Drive. [Check it out](https://github.com/alanvardy/dbbackup) and let me know what you think!
