defmodule AlanVardyWeb.PageController do
  @moduledoc false
  use AlanVardyWeb, :controller

  @doc false
  @spec index(Plug.Conn.t(), map) :: Plug.Conn.t()
  def index(conn, _params) do
    render(conn, "index.html", page_title: "Welcome")
  end

  @doc false
  @spec aboutme(Plug.Conn.t(), map) :: Plug.Conn.t()
  def aboutme(conn, _params) do
    render(conn, "aboutme.html", page_title: "About Me")
  end
end
