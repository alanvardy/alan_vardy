==title==
Set up Rubocop

==author==
Alan Vardy

==footer==


==description==
A quick configuration for Rubocop

==tags==
linux,ruby,rails,rubocop

==body==
Rubocop is great! Checks your Ruby code for style issues and will even format your code. This is my quick setup on a new project.

Install Rubocop

```bash
gem install rubocop rubocop-performance rubocop-rails

# you can add rubocop-rspec to this list as well if applicable
```

Create your config file in the root of your project directory

```bash
touch .rubocop.yml
```

And enter some sane Rails-friendly settings to override the defaults :)

```yaml
require:
  - rubocop-performance
  - rubocop-rails
AllCops:
  Exclude:
    - 'db/**/*'
    - 'config/**/*'
    - 'script/**/*'
    - 'bin/{rails,rake}'
Style/FrozenStringLiteralComment: { Enabled: false }
Style/MutableConstant: { Enabled: false }

# ------------I use this only for personal projects------------------
Metrics/LineLength: {AutoCorrect: true, Max: 80}

# ------And this only when playing in other kid's sand pits----------
Metrics/LineLength: {AutoCorrect: false, Max: 120}
Style/SymbolArray: { Enabled: false }
Style/WordArray: { Enabled: false }
Style/RescueStandardError: { Enabled: false }
Style/IfUnlessModifier: { Enabled: false }
Style/BracesAroundHashParameters: { Enabled: false }
Style/ParenthesesAroundCondition: { Enabled: false }
Style/RedundantParentheses: { Enabled: false }
Style/TernaryParentheses: { Enabled: false }
```

You can now install your editors extensions or format ALL the things with `rubocop -a`
