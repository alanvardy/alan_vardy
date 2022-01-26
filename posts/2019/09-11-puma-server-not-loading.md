==title==
Rails 6 Upgrade Gotcha: Puma Server Not Loading

==author==
Will Gabriel

==footer==


==description==
Updating a Rails site from 5.2 to 6.0? Having Puma issues? Check out this article for the solution.

==tags==
ruby,rails,servers

==body==

_Guest post by [Will Gabriel](https://github.com/thewillgabriel)_

Updating a Rails 5.2 site to 6.0 is relatively straightforward for a project with a small list of well-managed dependencies. However, though everything might be working in your development environment (or even in your `rails s -e production` tests), it might still fail on your production server.

If you use Puma to serve Rails in your production environment, you may have noticed `rails app:update` adding the following lines to your `/config/puma.rb` file:

```
# Specifies the `pidfile` that Puma will use.
pidfile ENV.fetch("PIDFILE") { "tmp/pids/server.pid" }
```

Puma's "pidfile", or _process ID file_, is where Puma stores the unique ID it uses while it's running. A server admin or another process on the system may use this number to check Puma's status or issue the process a `kill` command if necessary. Unfortunately, if the directory Puma wants to store this file doesn't exist, Puma won't start at all:

```
Errno::ENOENT: No such file or directory @ rb_sysopen - tmp/pids/server.pid
```

Creating this folder in your project repository isn't quite enough—and in fact, in your local repository, it's probably already there. The `/tmp/` folder is added to `/.gitignore` by default, and for good reason: `/tmp/` can be a dumping ground for temporary files and caches, and you usually don't want to commit these files. In order to ignore the files that should be ignored and still commit the above pidfile directory to your remote repository, you’ll need to add the following lines to your .gitignore file:

```plaintext
# Ignore all logfiles and tempfiles.
/log/*
/tmp/*
/tmp/pids/*              # this line
!/log/.keep
!/tmp/.keep
!/tmp/pids               # this line
!/tmp/pids/.keep         # and this line
```

The bang (!) denotes an exception. Since `/tmp/*` is on the ignore list, we need to explicitly allow `/tmp/pids` to be tracked. But that's not enough; git won't commit empty directories, so we need to add a file to that directory. An empty .keep file is a common method of handling this and making sure the directory holding it can get pushed up. 

The other two lines we add, `/tmp/pids/*` and `!/tmp/pids/.keep`, are a precaution. We don't want to share any files that don't need to be shared, and publicly broadcasting the process ID of our server instance feels sloppy. Therefore, we should exclude all the contents of `/tmp/pids/` from our commits _except_ for the .keep file itself.
