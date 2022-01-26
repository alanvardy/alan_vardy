==title==
Make a contact form with Mailgun

==author==
Alan Vardy

==footer==


==description==
Create a Rails contact form with Mailgun

==tags==
ruby,rails

==body==
Making a contact form can be surprisingly difficult, a number of pieces have to work together to make the magic happen and that is what this post is all about! For this article I am using:

- Ruby on Rails 5 (The excellent web framework)
- Mailgun (The email service)
- Namecheap (DNS)
- Heroku (Web hosting)

Let's get started!

# Sign up for Mailgun

Make yourself an account at [mailgun.com](https://www.mailgun.com/).

Specify that you want to use a mg subdomain, so that you will end up using mg.yourdomain.com for Mailgun.

# Add DNS Settings

Mailgun will not work until they read the proper DNS settings from your provider. For most providers the Mailgun-provided settings will be sufficient, but Namecheap was a whole different ball of wax (lucky me!). I have Namecheap's "Private Email Service" and have included those settings as well.

Private email:

| Hostname | Record Type | Priority | Value                                    |
| -------- | ----------- | -------- | ---------------------------------------- |
| @        | MX          | 10       | mx1.privateemail.com                     |
| @        | MX          | 10       | mx2.privateemail.com                     |
| @        | TXT         |          | v=spf1 include:spf.privateemail.com ~all |

Mailgun host records:

| Hostname         | Record Type | Value                 |
| ---------------- | ----------- | --------------------- |
| email.mg         | CNAME       | mailgun.org.          |
| mx._domainkey.mg | TXT         | k=rsa; p=MIGfM... etc |

Mailgun mail settings:

| Hostname | Record Type | Priority | Value            |
| -------- | ----------- | -------- | ---------------- |
| mg       | MX          | 10       | mxa.mailgun.org. |
| mg       | MX          | 10       | mxa.mailgun.org. |

# You don't need the Mailgun Heroku addon

That's right, I use a config var instead.

# Add config vars

Now add that .env file to your .gitignore. This is vital, if you don't do this then the whole world will have access to your api keys. That is bad.

Set up your gitignore in the main project directory

```bash
touch .gitignore
echo '.env' >> .gitignore
git add .
git commit -m 'add env to gitignore'
git push
```

and add your Mailgun config var to your .env in the  main project directory. This allows you to use config variables locally when you run 'heroku local'. You can alternately [install the dotenv gem](https://github.com/bkeepers/dotenv) to load the .env with `rails server`

```bash
touch .env
echo 'mailgun_secret_api_key=XXXXXXXXXXXX' >> .env
```

And add the same to Heroku so you can use the config var in production

```bash
heroku config:set mailgun_secret_api_key=XXXXXXXXXXXX
```

# Add the gem

```ruby
# Gemfile

gem 'mailgun-ruby'
```

and install it

```bash
bundle install
```

# Code

Create the model

```bash
rails generate model Messages --skip-migration
```

Use this code for the model:

```ruby
# message.rb

require 'mailgun-ruby'

class Message
  include ActiveModel::Model
  attr_accessor :name, :email, :phone_number, :body
  validates :name, :email, :phone_number, :body, presence: true

  def send
    mg_client = Mailgun::Client.new ENV['mailgun_secret_api_key']
    info = {
      from: email,
      to:   'YOU@YOUREMAIL.com',
      subject: "Email from #{name} - YOURDOMAIN.com",
      text:    "From: #{name}\nEmail: #{email}\nPhone: #{phone_number}\n\n #{body}"

                  }
    mg_client.send_message 'mg.YOURDOMAIN.com', info
  end
end
```

Create the controller

```bash
rails generate controller Messages new create
```

Use this code for the controller:

```ruby
# messages_controller.rb

class MessagesController < ApplicationController
  def new
    @message = Message.new
  end
def create
    @message = Message.new message_params
if @message.valid?
      @message.send
      redirect_to root_path
      flash[:success] = "I have received your message and will be in touch soon!"
    else
      flash[:warning] = "There was an error sending your message. Please try again."
      render :new
    end
  end
private
def message_params
    params.require(:message).permit(:name, :email, :phone_number, :body)
  end
end
```

and finally the code for new.html.erb

```erb
<%= form_for @message, url: messages_create_path do |f| %>
            <div class="form-group">
            <%= f.label :name %>
            <%= f.text_field :name, class: 'form-control'%>
            </div>

            <div class="form-group">
            <%= f.label :email %>
            <%= f.email_field :email, class: 'form-control'%>
            </div>

            <div class="form-group">
            <%= f.label :phone_number %>
            <%= f.telephone_field :phone_number, class: 'form-control'%>
            </div>

            <div class="form-group">
            <%= f.label :body %>
            <%= f.text_area :body, class: 'form-control', rows: '5'%>
            </div>

            <div class="form-group">
            <%= f.submit 'Send Form', class: 'btn btn-outline-primary'%>
            </div>
        <% end %>
```

Start up your local server

```bash
heroku local
# or rails server if you installed the dotenv gem
```

And let me know if you have any issues!
