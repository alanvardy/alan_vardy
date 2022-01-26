==title==
Make an awesome Bootstrap color scheme

==author==
Alan Vardy

==footer==


==description==
Set up a simple administrative account for use in simple applications such as blogs.

==tags==
bootstrap,sass

==body==
Bootstrap's color scheme is pretty good, they have some nice vibrant colors and you can make things look rather decent without much effort. The only problem is that if you stick with that color scheme you will soon discover that your website looks like thousands of others on the internet.

Also, you may want more colors. Here is how you can change and add colors to Bootstrap using Sass.


```sass
$theme-colors: ("grey0": hsl(0, 0%, 93%),
"grey1": hsl(0, 2%, 80%),
"grey2": hsl(0, 3%, 70%),
"grey3": hsl(0, 1%, 49%),
"primary": hsl(205, 44%, 36%),
"secondary": hsl(220, 2%, 27%),
"dark": hsl(206, 31%, 13%),
"danger": hsl(4, 55%, 36%),
"warning": hsl(10, 61%, 50%),
"info": hsl(234, 82%, 70%),
);

@import "bootstrap";
```

and now you can use these new colors in your Bootstrap classes like `bg-grey1` or `text-warning`.

Oh, but how do you access these variables in your Sass?

...with `map_get($theme-colors, 'COLOR');`

```sass
.someclass {
    text: map_get($theme-colors, 'grey2');
}
```
