==title==
Add an administrative account

==author==
Alan Vardy

==footer==


==description==
Set up a simple administrative account for use in simple applications such as blogs.

==tags==
ruby,rails

==body==
So you want an administrative account, but don't want to scaffold out a whole Users model for just one login? Enter the simple admin login! There is no database used, your username and password are stored in config variables (make sure you gitignore that .env file!), and you are logged in under a session.

This is best used for simple applications where damages from compromised authentication would be minimal. Use a real authentication system with has_secure_password or devise for a situation where more is on the line.

My code includes some Bootstrap styling, the code will work without it as well.

add .env and gitignore

```bash
# .env

ADMIN_USERNAME=foo
ADMIN_PASS=bar
```

add dotenv gem

```ruby
# Gemfile

gem 'dotenv-rails', groups: [:development, :test]
```

and install

```bash
bundle install
```

Create your Admin model

```bash
rails generate model Admin --skip-migration
```

Copy in the code

```ruby
# admin.rb

class Admin
  include ActiveModel::Model
  attr_accessor :username, :password

  def login_valid?
    @username == ENV['ADMIN_USERNAME'] && @password == ENV['ADMIN_PASS']
  end
end
```

Make your session controller

```bash
rails generate controller Session new create destroy
```

and copy in the code

``` ruby
#session_controller.rb

class SessionController < ApplicationController
  def new
    @admin = Admin.new
  end

  def create
    admin_params = params.require(:admin).permit(:username, :password)

    @admin = Admin.new
    @admin.username = admin_params[:username]
    @admin.password = admin_params[:password]

    if @admin.login_valid?
      session[:admin] = true
      flash[:success] = 'You have logged in'
      redirect_to root_path
    else
      @admin.password = nil
      flash[:notice] = 'Sorry, wrong credentials'
      render 'new'
    end
  end

  def destroy
    reset_session
    flash[:success] = 'You have logged out'
    redirect_to root_path
  end
end
```

Add in your log in code

``` html
<!-- new.html.erb -->

<h1>Log In</h1>
<div class="content">
    <section>
    <div class="row d-flex justify-content-center">
    <div class="col-12 col-md-6 col-lg-4">
    <h1>Admin Login</h1>
      <%= form_for @admin, url: session_create_path do |f| %>
        <div class="form-group">
          <%= f.label :username %>
          <%= f.text_field :username, class: 'form-control'%>
        </div>

        <div class="form-group">
          <%= f.label :password %>
          <%= f.password_field :password, class: 'form-control'%>
        </div>

        <div class="form-group">
          <%= f.submit 'Log In', class: 'btn btn-outline-primary'%>
        </div>
      <% end %>
    </div>
    </div>
    </section>
</div>
```

Add to your application helper

```ruby
# application_helper.rb

def admin?
    session[:admin]
end
```

Add log in/log out within the body tags, below the yield in application.html.erb

``` html
<!-- application.html.erb -->

<p class="text-center">
    <% if admin? %>
        You are logged in<br><%= link_to 'Log out', session_destroy_path, class: 'btn btn-sm btn-outline-info' %>
    <% else %>
        You are logged out<br><%= link_to 'Log in', session_new_path, class: 'btn btn-sm btn-outline-info' %>
    <% end %>
</p>

```

Add to the top of controllers you want authentication for

```ruby

before_action :authentication_required!, except: %i[index list show]
```

Add to your application controller

```ruby
class ApplicationController < ActionController::Base
  ApplicationNotAuthenticated = Class.new(StandardError)

  rescue_from ApplicationNotAuthenticated do
    respond_to do |format|
      format.json { render json: { errors: [message: "401 Not Authorized"] }, status: 401 }
      format.html do
        flash[:notice] = "Not Authorized to access this page, please log in"
        redirect_to new_session_path
      end
      format.any { head 401 }
    end
  end

  def authentication_required!
    session[:current_user] || raise(ApplicationNotAuthenticated)
  end
end
```
