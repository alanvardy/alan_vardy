==title==
Add automated testing with Guard

==author==
Alan Vardy

==footer==


==description==
Make your tests run automagically when you write Ruby code

==tags==
ruby,rails,testing

==body==
The guardfile is sourced from [Michael Hartl’s Ruby on Rails Tutorial](https://www.railstutorial.org/book), which is widely considered to be the best tutorial on Rails.

Following these steps will enable you to use some basic automated testing at the command line. Whenever you change one of the files specified in the Guardfile, Guard will automatically re-run the tests. Anything you can do to lower the "friction" of running tests is a good thing.

I use Terminator for my terminal, as it splits into smaller “sub terminals”. One will be for running a local server, another for automated testing, and a third for everything else like git commands and installing gems.

# The Steps

Add Guard to gemfile

```ruby
# Gemfile
# There will be other gems in here

group :test do
# other test gems
 gem 'guard'
 gem 'guard-minitest'
end
```

Install gems

```bash
bundle install
```

Initialize Guard

```bash
bundle exec guard init
```

and paste the following code into your Guardfile

```ruby
# Guardfile

# Defines the matching rules for Guard.

guard :minitest, spring: true, all_on_start: false do
 watch(%r{^test/(.*)/?(.*)_test\.rb$})
 watch('test/test_helper.rb') { 'test' }
 watch('config/routes.rb')    { integration_tests }
 watch(%r{^app/models/(.*?)\.rb$}) do |matches|
   "test/models/#{matches[1]}_test.rb"
 end
 watch(%r{^app/controllers/(.*?)_controller\.rb$}) do |matches|
   resource_tests(matches[1])
 end
 watch(%r{^app/views/([^/]*?)/.*\.html\.erb$}) do |matches|
   ["test/controllers/#{matches[1]}_controller_test.rb"] +
     integration_tests(matches[1])
 end
 watch(%r{^app/helpers/(.*?)_helper\.rb$}) do |matches|
   integration_tests(matches[1])
 end
 watch('app/views/layouts/application.html.erb') do
   'test/integration/site_layout_test.rb'
 end
 watch('app/helpers/sessions_helper.rb') do
   integration_tests << 'test/helpers/sessions_helper_test.rb'
 end
 watch('app/controllers/sessions_controller.rb') do
   ['test/controllers/sessions_controller_test.rb',
    'test/integration/users_login_test.rb']
 end
 watch('app/controllers/account_activations_controller.rb') do
   'test/integration/users_signup_test.rb'
 end
 watch(%r{app/views/users/*}) do
   resource_tests('users') +
     ['test/integration/microposts_interface_test.rb']
 end
end

# Returns the integration tests corresponding to the given resource.

def integration_tests(resource = :all)
 if resource == :all
   Dir['test/integration/*']
 else
   Dir["test/integration/#{resource}_*.rb"]
 end
end

# Returns the controller tests corresponding to the given resource.

def controller_test(resource)
 "test/controllers/#{resource}_controller_test.rb"
end

# Returns all tests for the given resource.
def resource_tests(resource)
 integration_tests(resource) << controller_test(resource)
end
```

Now you can start the automated tests by running

```bash
bundle exec guard
```

I recommend adding an alias to your terminal shell of choice!
