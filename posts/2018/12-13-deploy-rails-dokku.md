==title==
Deploy a Rails app with Dokku and Digital Ocean

==author==
Alan Vardy

==footer==

==description==
Deploy a Rails app to production with Dokku and Digital Ocean

==tags==
ruby,rails,dokku,digitalocean

==body==
Credit to [Dave Kiss](https://davekiss.com/create-your-own-heroku-clone-for-5-a-month-with-dokku/)

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

# Update and create an app on your server

SSH onto your server

```bash
ssh root@your.droplet.ip.address
```

Update everything (Digital Ocean's droplets will not be completely up to date, and Dokku can easily be a few versions behind)

```bash
apt update && apt upgrade
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

# Make a Rails App

```bash
rails new awesomeapp --database=postgresql
```

# Add a page and a route

```bash
cd awesomeapp
rails generate controller Static index
```

Add something to that index page in app/views

And add to config/routes.rb

```ruby
root 'static#index'
```

# Automatic Migrations

This one just runs `rails db:migrate` automatically.

Create app.json in the root directory of your app

```json
{
  "name": "awesomeapp",
  "description": "My awesome Rails app, running on Dokku!",
  "keywords": [
    "dokku",
    "rails"
  ],
  "scripts": {
    "dokku": {
      "postdeploy": "bundle exec rails db:migrate"
    }
  }
}
```

# Add checks

This feature is rather nice, it makes Dokku check to make sure that your freshly uploaded code actually starts up before switching over to it!

Create a file called CHECKS in the root of your project directory

```bash
# CHECKS

WAIT=10  
ATTEMPTS=6  
/check.txt it_works
```

Add the following route to config/routes.rb

```ruby
get '/check.txt', to: proc {[200, {}, ['it_works']]}
```

And it will make a call to that route when it starts up your new code, thereby ensuring that the new server actually started.

# Add your secrets file

```yml
# config/secrets.yml
production:
  secret_key_base: <%= ENV["SECRET_KEY_BASE"] %>
```

# Set up Puma correctly

If you are using Rails 6, [take a look at this post](https://www.alanvardy.com/posts/puma-server-not-loading) to save yourself some headache in getting Puma up and running.

# Add remote repository

Navigate to your awesomeapp project directory and add the repository

```bash
git remote add dokku dokku@your.droplet.ip.address:awesomeapp
```

# Set your config variables

Run `bundle exec rake secret` and copy the result for your server's secret\_key\_base. This is stored on your server as an environment variable.

```bash
dokku config:set RAILS_ENV=production SECRET_KEY_BASE=yoursecretkeybasethatyoucopied
```

You can now push your code with

```bash
git add .
git commit -m 'rails new'
git push dokku master
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

I wrote a shell script for this very issue. It downloads all your Postgres databases from Heroku and Dokku and uploads them (conveniently dated) to Google Drive. [Check it out](https://github.com/alanvardy/dbbackup) and let me know what you think!
