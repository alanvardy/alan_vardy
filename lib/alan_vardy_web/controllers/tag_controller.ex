defmodule AlanVardyWeb.TagController do
  @moduledoc false
  use AlanVardyWeb, :controller
  alias AlanVardy.Blog

  @doc false
  @spec show(Plug.Conn.t(), map) :: Plug.Conn.t()
  def show(conn, %{"id" => tag}) do
    posts = Blog.posts_tagged_with(tag)
    page_title = "##{tag}"

    render(conn, "show.html", page: 1, tag: tag, posts: posts, page_title: page_title)
  end
end
