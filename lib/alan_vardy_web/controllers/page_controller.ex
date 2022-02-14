defmodule AlanVardyWeb.PageController do
  use AlanVardyWeb, :controller

  @spec index(Plug.Conn.t(), map) :: Plug.Conn.t()
  def index(conn, _params) do
    render(conn, "index.html", page_title: "Welcome")
  end

  @spec aboutme(Plug.Conn.t(), map) :: Plug.Conn.t()
  def aboutme(conn, _params) do
    render(conn, "aboutme.html", page_title: "About Me")
  end
end
