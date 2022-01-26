==title==
How to install Postgres on Arch/Manjaro

==author==
Alan Vardy

==footer==


==description==
Install, enable, and create a user account

==tags==
linux,postgres

==body==
Install Postgresql with yay.

```bash
sudo yay postgresql
sudo yay postgresql-libs
```

Initialize

```bash
sudo su postgres -l # or sudo -u postgres -i
initdb --locale $LANG -E UTF8 -D '/var/lib/postgres/data/'
exit
```

Start and enable the service

```bash
systemctl start postgresql.service
systemctl enable postgresql.service
```

and then add your username

```bash
sudo -u postgres -i
createuser --interactive
YOUR_USER_NAME
y
logout
```
