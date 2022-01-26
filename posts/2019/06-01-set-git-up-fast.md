==title==
Set git up fast

==author==
Alan Vardy

==footer==


==description==
Quick copy paste commands to get started with git

==tags==
linux,git

==body==
Install git using the package manager of your choice.

and then configure with the following commands, this will set your code to Visual Studio Code

```bash
git config --global user.name "Your Name"
git config --global user.email you@email.com
# This sets VS code as your code editor
git config --global core.editor "code" # Sets the git editor to VS Code
# Some nice completely optional commands
sudo npm install -g git-removed-branches
sudo pip install git-sweep || easy_install git-sweep
```
