defmodule AlanVardy.Blog do
  @moduledoc "The blog context"
  use Postex, prefix: "https://www.alanvardy.com/posts/", per_page: 5
end
