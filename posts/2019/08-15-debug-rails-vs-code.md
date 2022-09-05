==title==
Debug Ruby on Rails with VS Code

==author==
Alan Vardy

==footer==

==description==
Quick tip on how to use Ruby debugging in VS Code

==tags==
ruby,rails,vscode

==body==
Credit to [Dāvis Namsons](https://dev.to/dnamsons/ruby-debugging-in-vscode-3bkj)

This one is nice and easy

Make sure that you have the [Ruby extension](https://marketplace.visualstudio.com/items?itemName=rebornix.ruby) installed.

Install your required gems (check the referenced link if you are pre Ruby 2.0

```bash
gem install ruby-debug-ide
gem install debase
```

Go into your debug menu and click:

1. No Configurations
2. Add Configuration
3. Ruby
4. Rails server

A launch.json file will be created, now you just need to launch the debugger, which will launch your Rails server in the debug console!
