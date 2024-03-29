defmodule AlanVardyWeb.PageControllerTest do
  use AlanVardyWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "My name is Alan Vardy, I am a Senior Developer"
  end

  test "GET About Me", %{conn: conn} do
    conn = get(conn, Routes.page_path(conn, :aboutme))
    assert html_response(conn, 200) =~ "This is the part where I get to talk about myself!"
  end
end
