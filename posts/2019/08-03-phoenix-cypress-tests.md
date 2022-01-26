==title==
Set up Phoenix acceptance tests with Cypress

==author==
Alan Vardy

==footer==


==description==
Step by step instructions to set up acceptance testing that actually works

==tags==
elixir,phoenix,cypress,ci

==body==
I really didn't expect this to work as well as it did in the end, patched together with a few shell scripts! [Cypress](https://www.cypress.io/) is a very slick end to end testing framework and Phoenix needs a good way to do acceptance tests. The two Elixir alternatives are Hound and Wallaby (both of which I struggled with before landing on Cypress).

What this solution gets at the end of the day is a single threaded series of Cypress tests that can be run with a single command. I hope to improve this and get multiple threads running later, but for now it is at least convenient for Continuous Integration and the occasional  developer check.

Let's get started!

# Install Cypress

The binary can be pulled in using npm (don't forget to return to your main app directory afterwards).

```bash
cd assets/
npm install cypress --save-dev
```

# Add systemtest configuration

Add a new config file: `/config/systemtest.exs`. This will give us a 4th environment, and a 4th database which will persist between system tests and be wipeable. It is very similar to the test.exs except with a different database name, server: true and no sandboxing.

```elixir
# /config/systemtest.exs

use Mix.Config

# Configure your database
config :yourapp, YourApp.Repo,
  username: "postgres",
  password: "postgres",
  database: "yourapp_systemtest",
  hostname: "localhost",
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

# We don't run a server during test, but we need it for systemtest!
config :yourapp, YourAppWebWeb.Endpoint,
  http: [port: 5000],
  server: true

# Print only warnings and errors during test
config :logger, level: :warn
```

# Add shell scripts

There are three shell scripts that are very similar... one runs Cypress in the console, and the other opens up the Cypress window so the developer can visually run through the test. Put these in the main app directory.

```bash
# cypress-run.sh

MIX_ENV=systemtest mix ecto.reset
echo "===STARTING PHX SERVER==="
echo "===IF STARTING CYPRESS FAILS==="
echo "===RUN npm install cypress --save-dev ==="
echo "===IN THE assets/ FOLDER==="
MIX_ENV=systemtest mix phx.server &
pid=$! # Store server pid
./assets/node_modules/.bin/cypress run
result=$?
kill -9 $pid # kill server
echo "===KILLING PHX SERVER==="
exit $result
```

```bash
# cypress-open.sh

MIX_ENV=systemtest mix ecto.reset # Need a blank database
echo "===STARTING PHX SERVER==="
echo "===IF STARTING CYPRESS FAILS==="
echo "===RUN npm install cypress --save-dev ==="
echo "===IN THE assets/ FOLDER==="
MIX_ENV=systemtest mix phx.server &
pid=$! # Store server pid
./assets/node_modules/.bin/cypress open
result=$?
kill -9 $pid # Kill server
echo "===KILLING PHX SERVER==="
exit $result # Return test result
```


```bash
# cypress-ci.sh

MIX_ENV=systemtest mix ecto.reset
echo "===STARTING PHX SERVER==="
echo "===IF STARTING CYPRESS FAILS==="
echo "===RUN npm install cypress --save-dev ==="
echo "===IN THE assets/ FOLDER==="
MIX_ENV=systemtest mix phx.server &
pid=$! # Store server pid
./assets/node_modules/.bin/cypress run  --record --key 114a5558-7d13-4b81-a67e-3deb9e3f073d
result=$?
kill -9 $pid # kill server
echo "===KILLING PHX SERVER==="
exit $result
```

And set the bash scripts as executable (or else they are not going to do much)

```bash
chmod +x cypress-run.sh
chmod +x cypress-open.sh
chmod +x cypress-ci.sh
```

# Add Mix aliases

And add the appropriate mix aliases to mix.exs

```elixir
defp aliases do
[
    ...
      "cypress.open": ["cmd ./cypress-open.sh"],
      "cypress.ci": ["cmd ./cypress-ci.sh"],
      "cypress.run": ["cmd ./cypress-run.sh"]
]
```

# Initialize Cypress

To create the folder structure you need to 'open' the Cypress window, Run the command now with the mix command.

```bash
mix cypress.open
```

# Write some cool tests

Here is an example of what I am working on right now in `cypress/integration/acceptance_test` folder

```javascript
describe('Acceptance Test', function () {
  beforeEach(function () {
    // before each test, we can automatically preserve the
    // 'session_id' and 'remember_token' cookies. this means they
    // will not be cleared before the NEXT test starts.
    //
    // the name of your cookies will likely be different
    // this is just a simple example
    Cypress.Cookies.debug(true)
    Cypress.Cookies.preserveOnce('_health_key')
  })

  it('Visits the main page', function () {
    cy.visit('http://localhost:5000')
  })

  it('Registers an account', function () {
    cy.contains('Register').click()
    cy.get('input#user_email').type('test@test.com')
    cy.get('input#user_name').type('Testy McTestface')
    cy.get('input#user_password').type('securepassword')
    cy.get('input#user_confirm_password').type('securepassword')
    cy.get('[type=submit]').click()
    cy.contains('Welcome back Testy McTestface')
  })

  it('Enters a weight record', function () {
    cy.contains('Weight').click()
    cy.get('#trend').find('input#log_weight').type('234')
    cy.get('#trend').find('[type=submit]').click()
    cy.contains('Recent Logs').click()
    cy.contains('234.0')
  })
})
```

Note that I am directing the test to go to localhost:5000 (as specified in the systemtest.exs), and I am registering (because the database is empty). Maybe I will get more sophisticated in the future, but for now this works just fine!

# CI

I added the following commands AFTER my regular tests in CircleCI

```yaml
      - run: cd assets && npm install && npm install cypress --save-dev && cd ..
      - run: mix cypress.run
```

Note that `npm install` is not enough by itself, you need to run `npm install cypress --save-dev` properly install.

# Running the test concurrently with everything else

I am completely enamoured with [ex_check](https://github.com/karolsluszniak/ex_check) for running my checks concurrently. You can add cypress to your `.check.exs` file with

```elixir
{:cypress, command: "mix cypress.run"},
```

This will add some time to your CI, so I recommend using dialyzer as well to make the time worth it!

# End

This should work on CI and in your terminal with `mix cypress.run`, hope this helps someone!
