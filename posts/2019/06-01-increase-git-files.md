==title==
Increase the number of files git can track

==author==
Alan Vardy

==footer==


==description==
A quick command to allow git to track more files.

==tags==
linux,git

==body==
Have you worked on such a large project that git refuses to track them all?

Try increasing your max system watches!

This solution consumes more ram, so do more investigation before implementing if you are running in a low ram environment.

```bash
sudo sh -c "echo 'fs.inotify.max_user_watches=524288' >> /etc/sysctl.conf"
sudo sysctl -p
```
