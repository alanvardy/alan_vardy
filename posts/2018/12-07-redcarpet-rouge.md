==title==
Markdown and Code Blocks with Redcarpet and Rouge

==author==
Alan Vardy

==footer==


==description==
Make a nice blog with Markdown and syntax highlighting

==tags==
ruby,rails,sass

==body==
My first thought when I was creating this website was:

“How do I make my code blocks look nice if I don’t have a built-in content management system?”

Jekyll handles this nicely with Kramdown, but for Rails the solution needs 2 gems and a little bit of code.

# Initial code

First add the redcarpet and rouge gems to your gemfile

```ruby
# Gemfile

gem 'redcarpet'
gem 'rouge'
```

Then install your gems

```bash
# bash
bundle install
```

You can then add your code to your application helper. This is just pulling in the Redcarpet gem for markdown, adding rouge for code blocks, and setting the extensions.

```ruby
# application_helper.rb

module ApplicationHelper
 require 'redcarpet'
 require 'rouge'
 require 'rouge/plugins/redcarpet'

 class MarkdownRender < Redcarpet::Render::HTML
   def initialize(extensions = {})
     super extensions.merge(link_attributes: { target: '_blank' })
   end
   include Rouge::Plugins::Redcarpet
 end
end
```

# Sass

The code blocks use CSS for highlighting, so add the following to your sass file to make things pretty

```css
// application.scss

.highlight {

 border-radius: 5px;
 font-family: -apple-system, BlinkMacSystemFont, Segoe UI, Roboto, Oxygen-Sans, Ubuntu, Cantarell, Helvetica Neue, sans-serif;
 font-weight: normal;
 font-size: 15px;
 padding: 10px;
 padding-bottom: 0px;
 margin-bottom: 20px;

 pre {
   padding-bottom: 10px;
 }

 code,
 pre {
   color: #fdce93;
   background-color: #3f3f3f;
 }

 .hll {
   background-color: #222;
 }

 .err {
   color: #e37170;
   background-color: #3d3535;
 }

 .k {
   color: #f0dfaf;
 }

 .p {
   color: #41706f;
 }

 .cs {
   color: #cd0000;
   font-weight: 700;
 }

 .gd {
   color: #cd0000;
 }

 .ge {
   color: #ccc;
   font-style: italic;
 }

 .gr {
   color: red;
 }

 .go {
   color: gray;
 }

 .gs {
   color: #ccc;
   font-weight: 700;
 }

 .gu {
   color: purple;
   font-weight: 700;
 }

 .gt {
   color: #0040D0;
 }

 .kc {
   color: #dca3a3;
 }

 .kd {
   color: #ffff86;
 }

 .kn {
   color: #dfaf8f;
   font-weight: 700;
 }

 .kp {
   color: #cdcf99;
 }

 .kr {
   color: #cdcd00;
 }

 .ni {
   color: #c28182;
 }

 .ne {
   color: #c3bf9f;
   font-weight: 700;
 }

 .nn {
   color: #8fbede;
 }

 .vi {
   color: #ffffc7;
 }

 .c,
 .preview-zenburn .highlight .g,
 .preview-zenburn .highlight .cm,
 .preview-zenburn .highlight .cp,
 .preview-zenburn .highlight .c1 {
   color: #7f9f7f;
 }

 .l,
 .preview-zenburn .highlight .x,
 .preview-zenburn .highlight .no,
 .preview-zenburn .highlight .nd,
 .preview-zenburn .highlight .nl,
 .preview-zenburn .highlight .nx,
 .preview-zenburn .highlight .py,
 .preview-zenburn .highlight .w {
   color: #ccc;
 }

 .n,
 .preview-zenburn .highlight .nv,
 .preview-zenburn .highlight .vg {
   color: #dcdccc;
 }

 .o,
 .preview-zenburn .highlight .ow {
   color: #f0efd0;
 }

 .gh,
 .preview-zenburn .highlight .gp {
   color: #dcdccc;
   font-weight: 700;
 }

 .gi,
 .preview-zenburn .highlight .kt {
   color: #00cd00;
 }

 .ld,
 .preview-zenburn .highlight .s,
 .preview-zenburn .highlight .sb,
 .preview-zenburn .highlight .sc,
 .preview-zenburn .highlight .sd,
 .preview-zenburn .highlight .s2,
 .preview-zenburn .highlight .se,
 .preview-zenburn .highlight .sh,
 .preview-zenburn .highlight .si,
 .preview-zenburn .highlight .sx,
 .preview-zenburn .highlight .sr,
 .preview-zenburn .highlight .s1,
 .preview-zenburn .highlight .ss {
   color: #cc9393;
 }

 .m,
 .preview-zenburn .highlight .mf,
 .preview-zenburn .highlight .mh,
 .preview-zenburn .highlight .mi,
 .preview-zenburn .highlight .mo,
 .preview-zenburn .highlight .il {
   color: #8cd0d3;
 }

 .na,
 .preview-zenburn .highlight .nt {
   color: #9ac39f;
 }

 .nb,
 .preview-zenburn .highlight .nc,
 .preview-zenburn .highlight .nf,
 .preview-zenburn .highlight .bp,
 .preview-zenburn .highlight .vc {
   color: #efef8f;
 }
}

```

# Markdown text

I use “Posts” for modelling my blog posts in Rails.

```bash
rails generate scaffold Posts
```

Therefore I will use my posts helper for the markdown_text function, which references code in the application helper. This function takes a string full of markdown and spits out HTML.

```ruby
# posts_helper.rb

include ApplicationHelper

module PostsHelper
 def markdown_text(text)
   Redcarpet::Markdown.new(MarkdownRender, fenced_code_blocks: true).render(text).html_safe
 end
end
```

I can now call that function in any erb file referenced by the posts_controller

```ruby
# _post.html.erb

<%= markdown_text(@post.content) %>
```

or

```ruby
# some_file.html.erb

<%= markdown_text(“##Anything I want!”) %>
```

# Markdown files

Now something else I wanted to do was create static markdown pages (not just dynamic blog posts).

I generated a controller (with one page in this example)

```bash
rails generate controller Static index
```

And I created a markdown file in /app/assets/markdowns/

```markdown
example.md

# Title

Wow look at this page!

[Here is a link to Google!](https://www.google.com)
```

I add my markdown_file function to the static helper. Note how I reference the /app/assets/markdowns/

```ruby
# static_helper.rb

include ApplicationHelper

module StaticHelper
 def markdown_file(filename)
   path = Rails.root.join('app', 'assets', 'markdowns', filename)
   text = File.read(path)
   Redcarpet::Markdown.new(MarkdownRender, fenced_code_blocks: true).render(text).html_safe
 end
end
```

And then I can reference the file in my index

```ruby
# index.html.erb

<%=  markdown_file('example.md') %>
```

And it is done!
