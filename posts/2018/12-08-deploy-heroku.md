==title==
Deploy a simple website on Heroku

==author==
Alan Vardy

==footer==


==description==
Make it easier to keep your data backed up.

==tags==
ruby,sinatra,heroku

==body==
This is a simple guide with one intention: help get something online that a person can play with and improve.

# Phase 1: Getting Something Online

[Sign up for Heroku](http://www.heroku.com)

[Install command line heroku](https://devcenter.heroku.com/articles/heroku-cli)

Install bundler

```bash
gem install bundler
```

[Create new repo on Github with readme](https://docs.github.com/en/get-started/quickstart/create-a-repo)

Clone down to computer

```bash
git clone .....
cd directoryname
```

Add Gemfile

```bash
bundle init
```

Add Sinatra gem to Gemfile

```ruby
# Gemfile
source 'https://rubygems.org'
gem 'sinatra'
```

Install gems

```bash
bundle install
```

Create hello.rb

```ruby
# hello.rb
require 'sinatra'

get '/' do
  "Hello World!"
end
```

Test run it and open in browser with localhost and port number described

```bash
ruby hello.rb
```

Add config.ru for Heroku

```ruby
# config.ru

require './hello'
run Sinatra::Application
```

Push to Github

```bash
git add .
git commit -m 'first working version'
git push origin master
```

Create Heroku server (will need to log in the first time)

```bash
heroku create newappname
```

Push to Heroku server

```bash
git push heroku
```


# Phase 2: HTML

Create a views folder for html

```bash
mkdir views
```

Create views/index.erb

```erb
// views/index.erb

<html>
  <body>
    <h1>
      Index
    </h1>
    <p>
      Holy cow I'm a webpage!
    </p>
  </body>
</html>
```

Create views/contact.erb

```erb
// views/contact.erb

<html>
  <body>
    <h1>
      Contact
    </h1>
    <p>
      Leave me alone!
    </p>
  </body>
</html>
```

Create route to index and contact in hello.rb

```ruby
# hello.rb

require 'sinatra'

get '/' do
  erb :index
end
get '/contact' do
  erb :contact
end
```

Restart server, push to GitHub and Heroku

```bash
ruby hello.rb
git add .
git commit -m 'We have pages now'
git push origin master
git push heroku
```

# Phase 3: CSS

Create public/style.css

```css
/* public/style.css */
h1 {
  color: green;
}
```

Add to erb files:

```erb
<link href="style.css" rel="stylesheet">
```

Make sure it works!


# Phase 4: Add template

Add template file views/layout.erb

```erb
// views/layout.erb

<html>
  <body>
    <h1>
      I’m the Template Title!
    </h1>
      <%= yield %>
  </body>
</html>
```

Specify layout for each page in hello.rb

```ruby
# hello.rb
require 'sinatra'

get '/' do
  erb :index, layout: :layout
end
get '/contact' do
  erb :contact, layout: :layout
end
```

Change each page

```erb
<p>
  Holy cow I'm a webpage!
</p>
```

```erb
<p>
  Leave me alone!
</p>
```

# Phase 5: Add Variables

Add variable in hello.rb

```ruby
# hello.rb

require 'sinatra'

get '/' do
@title = ‘INDEX’
  erb :index, layout: :layout
end

get '/contact' do
@title = ‘CONTACT’
  erb :contact, layout: :layout
end
```

Add in template

```erb
<html>
  <body>
    <h1>
      <%= @title %>
    </h1>
      <%= yield %>
  </body>
</html>
```


# Phase 6: Add server reloader

Install shotgun

```bash
gem install shotgun
```

Restart server with shotgun

```bash
shotgun hello.rb
```

# Phase 7: Would you like to know more?

[Check out Jump Start Sinatra](https://www.sitepoint.com/premium/books/jump-start-sinatra)
