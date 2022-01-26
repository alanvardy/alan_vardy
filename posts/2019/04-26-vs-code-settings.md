==title==
Visual Studio Code Settings for Ruby and Elixir

==author==
Alan Vardy

==footer==


==description==
A dump of my current settings.json

==tags==
vs code, ruby, elixir

==body==
Getting VS Code settings right is *hard*.

This is a dump of what I am currently using to make the magic happen with Ruby and Elixir.

```json
{
  // RUBY SETTINGS
  // I hard coded some paths here that you will need to adjust yourself
  "[ruby]": {
    "rubocop.executePath": "/home/vardy/.rbenv/shims/",
    "editor.tabSize": 2,
    "ruby.codeCompletion": "rcodetools",
    "ruby.format": "rubocop",
    "editor.formatOnSave": true,
    "ruby.intellisense": "rubyLocate",
    "ruby.useLanguageServer": true,
    "ruby.linter.executablePath": "/home/vardy/.rbenv/shims/ruby",
    "solargraph.formatting": true,
    // Basic settings: turn linter(s) on
    "ruby.lint": {
      "reek": true,
      "rubocop": true,
      "ruby": true, //Runs ruby -wc
      "fasterer": true,
      "debride": true,
      "ruby-lint": true
    },

    // Time (ms) to wait after keypress before running enabled linters. Ensures
    // linters are only run when typing has finished and not for every keypress
    "ruby.lintDebounceTime": 500

    //advanced: set command line options for some linters:
  },

  "files.associations": {
    "*.erb": "erb",
    "*.leex": "HTML (Eex)"
  },

  // ELIXIR SETTINGS

  "[elixir]": {
    "editor.formatOnSave": true
  },

  "[HTML (Eex)]": {
    "editor.formatOnSave": true,
    "editor.tabSize": 2
  },

  // GIT SETTINGS
  "git.enableSmartCommit": true,
  "git.confirmSync": false,
  "git.autofetch": true,
  "git.autorefresh": true,

  "emmet.includeLanguages": {
    "erb": "html",
    "gitlens.hovers.enabled": false,
    "gitlens.codeLens.enabled": false,
    "git.fetchOnPull": true,
    "HTML (Eex)": "html"
  },
  // VISUAL
  "editor.cursorStyle": "line",
  "editor.cursorWidth": 5,
  "editor.cursorBlinking": "solid",
  "editor.renderWhitespace": "all",
  "editor.fontFamily": "Inconsolata",
  "terminal.integrated.fontSize": 15,
  "terminal.integrated.fontFamily": "Inconsolata",
  "editor.lineHeight": 25,
  "editor.letterSpacing": 0.5,
  "editor.fontWeight": "500",
  "editor.fontSize": 18,
  "editor.fontLigatures": true,
  "explorer.openEditors.visible": 0,
  "workbench.colorTheme": "One Dark Pro",
  "window.titleBarStyle": "custom",
  "workbench.editor.enablePreview": false,
  "materialTheme.fixIconsRunning": false,
  "highlight-matching-tag.enabled": true,
  "window.menuBarVisibility": "toggle",
  "materialTheme.autoApplyIcons": true,
  "window.zoomLevel": 0,
  "workbench.sideBar.location": "left",

  // BEHAVIOUR
  "terminal.integrated.rendererType": "dom",
  "liveServer.settings.donotShowInfoMsg": true,
  "debug.internalConsoleOptions": "neverOpen",
  "editor.acceptSuggestionOnEnter": "off",
  "explorer.confirmDragAndDrop": false,
  "explorer.confirmDelete": false,
  "liveServer.settings.donotVerifyTags": true,
  "files.autoSave": "afterDelay",
  "gitlens.currentLine.enabled": false, // in modern version
  "gitlens.codeLens.authors.enabled": false,
  "gitlens.codeLens.recentChange.enabled": false,

  // SETTINGS SYNC
  "sync.gist": "d437298a643172027750781275d349c9",
  "sync.quietSync": false,
  "sync.removeExtensions": true,
  "sync.syncExtensions": true,
  "sync.autoDownload": true,
  "sync.autoUpload": true,
  "sync.forceDownload": false,

  // FORMATTING
  // Enables beautification of more that just HTML :)
  "beautify.language": {
    "js": {
      "type": ["javascript", "json"],
      "filename": [".jshintrc", ".jsbeautifyrc"]
    },
    "css": ["css", "scss"],
    "html": {
      "type": ["htm", "html"],
      "filename": [".html.eex", ".html.leex", ".html.erb", ".html"]
    }
  },

  "files.trimTrailingWhitespace": true,
  "prettier.eslintIntegration": true,

  "cSpell.allowCompoundWords": true,
  "cSpell.userWords": [
    "dokku",
    "enrolments",
    "espcn",
    "language",
    "muahaha",
    "open",
    "postgresql",
    "rcodetools",
    "readline",
    "rsense",
    "rubocop",
    "signup",
    "strftime",
    "struct",
    "touchpad",
    "uncomment",
    "upcase",
    "vardy"
  ],
  "cSpell.language": "en",
  "cSpell.enabledLanguageIds": [
    "asciidoc",
    "c",
    "cpp",
    "csharp",
    "css",
    "go",
    "handlebars",
    "html",
    "jade",
    "javascript",
    "javascriptreact",
    "json",
    "latex",
    "less",
    "markdown",
    "php",
    "plaintext",
    "pub",
    "python",
    "restructuredtext",
    "ruby",
    "rust",
    "scss",
    "text",
    "typescript",
    "typescriptreact",
    "yml"
  ],
  "terminal.integrated.shell.linux": "/bin/zsh",

  "[markdown]": {
    // Remove trailing auto inserted whitespace.
    "editor.trimAutoWhitespace": false,
    // When enabled, will trim all new lines after the final new line at the end of the file when saving it.
    "files.trimFinalNewlines": false,
    // When enabled, will trim trailing whitespace when saving a file.
    "files.trimTrailingWhitespace": false
  },
  "[scss]": {
    "editor.tabSize": 2,
    "editor.formatOnSave": true
  },
  "[haml]": {
    "editor.tabSize": 2,
    "editor.formatOnSave": true,
    "editor.defaultFormatter": "misogi.ruby-rubocop"
  },
  "[javascript]": {
    "editor.insertSpaces": true,
    "editor.tabSize": 2,
    "editor.formatOnSave": true
  },
  "[json]": {
    "editor.insertSpaces": true,
    "editor.tabSize": 2,
    "editor.formatOnSave": true
  },
  "prettier.disableLanguages": ["vue", "markdown"],
  "liveshare.featureSet": "insiders",
  "editor.formatOnSave": true,
  "editor.formatOnType": true,
  "editor.formatOnPaste": true,
  "editor.formatOnSaveTimeout": 2000,
  "ruby.format": "rubocop",
  "workbench.iconTheme": "vscode-icons"
}
```
