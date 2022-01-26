==title==
Backup your Heroku databases with a shell script

==author==
Alan Vardy

==footer==


==description==
Make it easier to keep your data backed up.

==tags==
ruby,rails,linux

==body==
Please note that since writing this article I have created a shell script that downloads all your Heroku and Dokku Postgres databases and uploads them to Google Drive. [You can check it out here.](https://github.com/alanvardy/dbbackup)

# Original article

If your Heroku app isn’t professional tier, backups get a little more labour intensive. You will need to manually backup and download your databases and store them yourself.To help me do this, I wrote a shell script. 

First you need to create a shell script

```bash
touch backupdb.sh
```

open it

```bash
gedit backupdb.sh
```

Paste in the following code (Just replace the app1 app2 app3 etc. with the names of the apps you with to back up).

The script:

- creates a folder named after today's date
- loops once per app name
   - backs up the app
   - copies the backup url
   - downloads the backup

```bash
#!/bin/bash

apps=(app1 app2 app3)
DATE=`date +%Y-%m-%d`
mkdir -p "${DATE}"
for i in ${apps[@]}; do
   heroku pg:backups:capture --app ${i}
   url=$(heroku pg:backups:url --app ${i})
   wget -O $DATE/${i} $url
done
```

Make the script executable

```bash
chmod +x backupdb.sh
```

and run it!

```bash
./backupdb.sh
```

[Check out Heroku for more indepth information](https://devcenter.heroku.com/articles/heroku-postgres-backups)

