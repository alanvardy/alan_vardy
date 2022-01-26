==title==
Favicons on Rails

==author==
Alan Vardy

==footer==


==description==
Quickly add a favicon to your Rails website.

==tags==
ruby,rails

==body==
Such a little detail that it can be easy to miss! Chances are that this is one of that last things on your list and that you are looking forward to it 'just being done', so lets make this easy.

# Get the images

Make an image at least 260x260px (that doesn't have a lot of detail of course) and [convert it at this website](https://realfavicongenerator.net/).

You will receive an archive, put that archive's contents into your `app/assets/images/favicon` folder (you will need to create the favicon folder).

# Add the code

Put this in the head section of your application.html.erb file

```html
<%= favicon_link_tag asset_path('favicon/favicon.ico') %>
```

# Or do it the hard way

[Check this out](https://realfavicongenerator.net/favicon/ruby_on_rails) if you want to go further down the rabbit hole.
