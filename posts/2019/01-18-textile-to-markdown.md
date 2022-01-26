==title==
Convert Textile files to Markdown with a shell script

==author==
Alan Vardy

==footer==


==description==
A little shell scripting to make the bad textile files go away

==tags==
linux

==body==
Oh no! You have a ton of textile files which look like they are going the way of Betamax, and you wish that they were Markdown instead! Shell scripting to the rescue!

Install pandoc

```bash
sudo apt install pandoc
```

Navigate to your directory where the files are in the terminal of your choice and create your script file.

'''bash
cd your/file/directory
touch converter.sh
chmod +x converter.sh
gedit converter.sh
'''

Get a list of your filenames

```bash
find -name "*.textile"
```

And make your shell script using this as a template:

```bash
#!/bin/bash
#converter.sh

filenames=(file1 file2 file3 file4)

for i in ${filenames[@]}; do
        pandoc ${i}.textile -o ${i}.markdown

done
```

Save and run your converter

```bash
./converter.sh
```

Move your old textile files (I'm going to call them posts) into an old_posts directory

```bash
mkdir old_posts
mv *.textile old_posts
```

And you are done!
