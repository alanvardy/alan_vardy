==title==
Automate your Rails updates on GitHub

==author==
Alan Vardy

==footer==

==description==
Set up Travis CI and Dependabot

==tags==
ci,github,rails,ruby

==body==

Tired of upgrading things? If you have a good test suite that you can trust, there are excellent options out there for automating your dependency updates. This is a very quick rundown on setting up the process with Travis CI (for running your tests) and Dependabot (for opening pull requests).

This is a minimum effective setup to get you started!

# Sign up

First you need to register with [Travis CI](https://travis-ci.org/) and [Dependabot](https://dependabot.com/). Travis CI is (as of this writing) free for open source and Dependabot was acquired by Microsoft and is now free across the board.

# Connect them to your GitHub account

Make sure that they are authorised to access the applicable repositories, both through Github, and through selecting them in the Dependabot dashboard. Don't worry about the settings, we will handle it in the config file!

# Travis CI configuration

Create your config file

```bash
touch .travis.yml
```

and add the configuration:

```yaml
# .travis.yml

addons:
  postgresql: 9.6
before_install:
  - gem update --system
  - gem install bundler
before_script:
  - bundle exec rails db:create
language: ruby
script:
  - bundle exec rails db:migrate RAILS_ENV=test
  - bundle exec rails test
```

These all commands for Travis CI's container to run, starting with installing Postgresql and ending with running rails test.

# Dependabot configuration

Create your config file

```bash
mkdir .dependabot
touch .dependabot/config.yml
```

and add the configuration:

```yaml
# .dependabot/config.yml

version: 1
update_configs:
  - package_manager: "ruby:bundler"
    directory: "/"
    update_schedule: "live"
    default_reviewers:
    - "alanvardy" # change this to your github username!
```

You can find more configuration options [here](https://docs.github.com/en/code-security/dependabot/dependabot-version-updates/configuration-options-for-the-dependabot.yml-file)

Push your code to master and off you go!
