==title==
Installing ancient Ruby versions and Gems on Arch/Manjaro

==author==
Alan Vardy

==footer==


==description==
Having trouble installing an older Ruby version? Here is a collection of so some of my solutions.

==tags==
linux,asdf,ruby

==body==
This process ... sucks to put it lightly, hopefully my notes can save someone else pain!

You can also take a look at [this page for rbenv](https://wiki.archlinux.org/index.php/Rbenv) and [this one for asdf](https://github.com/asdf-vm/asdf-ruby/wiki/Ruby-Installation-Problems) 

## Ruby 2.1.5 (rbenv)

I had to install an older version of bundler as well.

```bash
curl -fsSL https://gist.github.com/mislav/055441129184a1512bb5.txt | PKG_CONFIG_PATH=/usr/lib/openssl-1.0/pkgconfig rbenv install --patch 2.1.5 -v
gem install bundler -v '1.17.1' 
```


## Ruby 2.2.3 (rbenv)

Install openssl-1.0

```bash
curl -fsSL https://gist.github.com/mislav/055441129184a1512bb5.txt | PKG_CONFIG_PATH=/usr/lib/openssl-1.0/pkgconfig rbenv install --patch 2.2.3 -v
```

## Ruby 2.3.3 (asdf)

```bash
PKG_CONFIG_PATH=/usr/lib/openssl-1.0/pkgconfig RUBY_EXTRA_CONFIGURE_OPTIONS="--with-openssl-dir=/usr/lib/openssl-1.0" asdf install ruby 2.3.3
```

## Ruby 2.3.3 (rbenv)

```bash
https://mikewilliamson.wordpress.com/2017/08/29/installing-ruby-2-3-on-archlinux/
sudo pacman -S openssl-1.0
PKG_CONFIG_PATH=/usr/lib/openssl-1.0/pkgconfig/:/usr/lib/pkgconfig/ RUBY_CONFIGURE_OPTS=--with-openssl-dir=/usr/lib/openssl-1.0/ rbenv install 2.3.3 -v
```

install imagemagick6 and replace current version

## rmagick 3.0.0 (rbenv)

Not compatible with ImageMagic 7, needs ImageMagick 6

```bash
sudo C_INCLUDE_PATH=/usr/include/ImageMagick-6/ gem install rmagick -v 3.0.0
```

## rmagick 3.0.0 (asdf)

Not compatible with ImageMagic 7, needs ImageMagick 6

```bash
C_INCLUDE_PATH=/usr/lib/imagemagick6 PKG_CONFIG_PATH=/usr/lib/imagemagick6/pkgconfig gem install rmagick -v 3.0.0
```

## Needs a pre 2.0 version of Bundler

```bash
gem install bundler:1.17.1
bundle _1.17.1_ install
```

## Install an older version of libmagick6

This may be required to install libmagick6

Disable signature checking (reverse these changes after!)

Open the config

```bash
sudo nano /etc/pacman.conf
```

And add this line

```bash
RemoteFileSigLevel = Optional
```

Downgrade your package

```bash
sudo pacman -U https://archive.archlinux.org/packages/l/libmagick6/libmagick6-6.9.10.56-1-x86_64.pkg.tar.xz
```

And re-enable your signature checking by removing that line from pacman.conf
