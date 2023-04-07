defmodule AlanVardyWeb.PostController do
  @moduledoc false
  use AlanVardyWeb, :controller
  alias AlanVardy.Blog
  alias AlanVardyWeb.ErrorView

  @doc false
  @spec index(Plug.Conn.t(), map) :: Plug.Conn.t()
  def index(conn, %{"page" => page}) do
    assigns = [
      page: page,
      posts: Blog.list_posts(page),
      tags: Blog.tags_with_count(),
      page_title: "Blog"
    ]

    render(conn, "index.html", assigns)
  end

  def index(conn, _params) do
    assigns = [
      page: 1,
      posts: Blog.list_posts(1),
      tags: Blog.tags_with_count(),
      page_title: "Blog"
    ]

    render(conn, "index.html", assigns)
  end

  @doc false
  @spec show(Plug.Conn.t(), map) :: Plug.Conn.t()
  def show(conn, %{"id" => id}) do
    case Blog.fetch_post(id) do
      {:ok, post} ->
        render(conn, "show.html", post: post, page_title: post.title)

      _ ->
        conn
        |> put_view(ErrorView)
        |> render("404.html")
    end
  end

  @doc false
  @spec rss(Plug.Conn.t(), any) :: Plug.Conn.t()
  def rss(conn, _params) do
    assigns = [posts: Blog.list_posts(), page_title: "RSS"]

    render(conn, "rss.xml", assigns)
  end
end
