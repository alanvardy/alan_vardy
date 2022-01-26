==title==
Install asdf on Arch/Manjaro with Oh-My-Zsh

==author==
Alan Vardy

==footer==


==description==
Simple commands to install oh-my-zsh

==tags==
linux,asdf,ruby,elixir

==body==
## Install asdf

[Check this link for more information](https://asdf-vm.com/#/core-manage-asdf-vm)

Ruby and Elixir are my drugs of choice.

```bash
git clone https://github.com/asdf-vm/asdf.git ~/.asdf

# reload terminal

asdf plugin-add ruby https://github.com/asdf-vm/asdf-ruby.git && \
asdf plugin-add erlang https://github.com/asdf-vm/asdf-erlang.git && \
asdf plugin-add elixir https://github.com/asdf-vm/asdf-elixir.git

echo -e '\n. $HOME/.asdf/asdf.sh' >> ~/.zshrc
echo -e '\n. $HOME/.asdf/completions/asdf.bash' >> ~/.zshrc

# reload terminal again!
```

Now you can install a language version using

```bash
# asdf install language version
asdf install ruby 2.6.3
```

Set your local language for a project (and create your .tool-versions file in the root)

```bash
# asdf install language version
asdf local ruby 2.6.3
```

and your global version

```bash
# asdf install language version
asdf install ruby 2.6.3
```

don't forget to add your .default-gems file in your home directory! It will install the specified gems every time you install a new ruby version.

```bash
touch ~/.default-gems
```

and put in your essentials!

```bash
rails
solargraph
reek
debride
fasterer
rubocop
rubocop-performance
rubocop-rails
bundler
pry
```
