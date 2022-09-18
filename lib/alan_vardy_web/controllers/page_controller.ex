defmodule AlanVardyWeb.PageController do
  @moduledoc false
  use AlanVardyWeb, :controller

  alias AlanVardy.Blog

  @doc false
  @spec index(Plug.Conn.t(), map) :: Plug.Conn.t()
  def index(conn, _params) do
    [latest_post | _] = Blog.list_posts(1)
    render(conn, "index.html", page_title: "Welcome", latest_post: latest_post)
  end

  @doc false
  @spec aboutme(Plug.Conn.t(), map) :: Plug.Conn.t()
  def aboutme(conn, _params) do
    render(conn, "aboutme.html", page_title: "About Me")
  end
end
