==title==
Add pagination to your posts

==author==
Alan Vardy

==footer==


==description==
Set up pagination in Rails

==tags==
ruby,rails,bootstrap

==body==
For this post I will be adding pagination with [will_paginate](https://github.com/mislav/will_paginate/wiki) and styling with Bootstrap

Add the gems to your Gemfile

```ruby
# Gemfile

gem 'will_paginate'
gem 'bootstrap-will_paginate'
```

and install

```bash
bundle install
```

Add this code to the top of your posts controller to allow will_paginate to process arrays. You will need this in order... to order your posts (see what I did there?).

```ruby
# posts_controller.rb

require 'will_paginate/array'
```

Replace your post controller's index method

```ruby
# posts_controller.rb

  def index
    @posts = Post.all.order(created_at: :desc).paginate(page: params[:page], per_page: 3)
  end
```

Add pagination to your posts index. This code requires that you use a partial called _post.html.erb in the same directory.

```html
<!–– posts/index.html.erb ––>

<h1>Latest Posts</h1>
<%= will_paginate %>
<%= render @posts %>
<%= will_paginate %>
```

Add some sweet Sass to separate the pagination links and turn the current page link bold.

```sass
// application.scss
       
.pagination {
  li {
  margin-right: 10px;
  }

  .active {
    font-weight: bold;
  }
}
```
