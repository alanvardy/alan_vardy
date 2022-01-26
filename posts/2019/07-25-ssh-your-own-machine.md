==title==
SSH into your own machine

==author==
Alan Vardy

==footer==


==description==
How to create an SSH server and SSH into your own machine

==tags==
linux,servers

==body==
Credit to [Grzegorz Juszczak](http://www.tuxfixer.com/configure-ssh-service-in-manjaro-linux/)

I am setting this up so I can SSH into any of the computers in my house to update them, transfer files, and even do remote development in VS Code (type on my laptop while the powerful desktop downstairs does all the compiling).

Because an SSH server is a convenient door for someone to brute force their way into I consider it VERY important that SSH keys are used, and that passwords are disabled.

## On Host Machine

Install OpenSSH (if needed)

```bash
sudo pacman -S openssh 
```

Verify that your SSH service is inactive (should be by default) then start and enable it.

```bash
sudo systemctl status sshd.service
sudo systemctl enable sshd.service
sudo systemctl start sshd.service
```

## On Client Machine

Add your ssh key to the server

```bash
ssh-copy-id -i username@your.server.ip.address
```

Disallow password authentication in `sshd_config`

```bash
ssh username@your.server.ip.address
sudo nano /etc/ssh/sshd_config
```

and change: `#PasswordAuthentication yes` to: `PasswordAuthentication no`

and save with `Ctrl + x`, `y`, `enter`

Then restart your SSH service

```bash
systemctl restart sshd.service
```
