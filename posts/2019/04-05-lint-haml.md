==title==
Lint your Haml files in VS Code

==author==
Alan Vardy

==footer==


==description==
Setup instructions for haml linting

==tags==
ruby,rails,haml,vs code

==body==
Next to ERB, haml can be a bit overwhelmimg. The code is terse and (unlike ERB) indentation *really* matters. 

I didn't realise until recently that linting haml is an option, and want to share my current configuration.

## Configure VS Code

Set tab size in your settings.json

```json
  "[haml]": {
    "editor.tabSize": 2,
  },
```

## Add VS Code Extensions

[Better Haml](https://marketplace.visualstudio.com/items?itemName=karunamurti.haml)

[Haml Lint](https://marketplace.visualstudio.com/items?itemName=aki77.haml-lint)

## Install Haml-lint gem

Add the [haml-lint](https://github.com/brigade/haml-lint) gem either manually

`gem install haml_lint`

or in your gemfile

`gem 'haml_lint', require: false`

## Add the configuration file

Create .haml-lint.yml in the base of your project directory

```bash
touch .haml-lint.yml
```

and add your configuration

```yaml
linters:
  InlineStyles: {enabled: false}
  LineLength: {enabled: true, max: 120}

  RuboCop:
    enabled: true
    # These cops are incredibly noisy when it comes to HAML templates, so we
    # ignore them.
    ignored_cops:
      - Lint/BlockAlignment
      - Lint/EndAlignment
      - Lint/Void
      - Layout/AlignHash
      - Layout/AlignParameters
      - Layout/ElseAlignment
      - Layout/EndOfLine
      - Layout/IndentationWidth
      - Layout/TrailingBlankLines
      - Layout/TrailingWhitespace
      - Metrics/BlockLength
      - Metrics/BlockNesting
      - Metrics/LineLength
      - Naming/FileName
      - Style/FrozenStringLiteralComment
      - Style/IfUnlessModifier
      - Style/Next
      - Style/WhileUntilModifier

  SpaceInsideHashAttributes: {enabled: false, style: space}
  ViewLength: {enabled: true, max: 120}
```
