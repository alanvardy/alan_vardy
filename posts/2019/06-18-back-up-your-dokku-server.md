==title==
Back up your Dokku Digital Ocean server

==author==
Alan Vardy

==footer==


==description==
A quick little post on how to use rsync to download your server to a local machine

==tags==
linux,servers,dokku,digital ocean

==body==
Want to do make an offsite backup? Heard the horror stories of what happens when Digital Ocean cuts you off (hint: you lose access to your backups too).

rsync to the rescue!

This command will transfer the folder, will all files inside, to the destination folder. In this case I am putting the dokku home folder (which contains all my Dokku containers) in my downloads folder.

```bash
rsync -azP --delete root@YOUR.IP.ADDRESS.HERE:/home/dokku ~/Downloads/
```
