==title==
Install rbenv and Ruby

==author==
Alan Vardy

==footer==


==description==
Install rebenv and Ruby on a Linux machine

==tags==
linux,ruby,rbenv

==body==
I don't use rbenv anymore (I have moved to asdf for the plugins), but these instructions may help someone else.

Install rbenv first from the package manager of your choice.

Configure it for your terminal

```bash
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(rbenv init -)"' >> ~/.bashrc
exit
```

Install the rbenv Ruby plugin

```bash
mkdir -p "$(rbenv root)"/plugins
git clone https://github.com/rbenv/ruby-build.git "$(rbenv root)"/plugins/ruby-build
```

Install Ruby (this does it globally)

```
rbenv install 2.6.3 --verbose
rbenv global 2.6.3
ruby -v
```
