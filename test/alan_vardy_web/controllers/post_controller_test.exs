defmodule AlanVardyWeb.PostControllerTest do
  use AlanVardyWeb.ConnCase

  test "GET index", %{conn: conn} do
    conn = get(conn, Routes.post_path(conn, :index))
    assert html_response(conn, 200) =~ "Blog"
    assert html_response(conn, 200) =~ "Previous"
    assert html_response(conn, 200) =~ "Next"
    assert html_response(conn, 200) =~ "3 Bad Arguments Against Writing Tests"
  end

  test "GET index page 2", %{conn: conn} do
    conn = get(conn, Routes.post_path(conn, :index, %{page: 2}))
    assert html_response(conn, 200) =~ "Blog"
    assert html_response(conn, 200) =~ "Previous"
    assert html_response(conn, 200) =~ "Next"
    assert html_response(conn, 200) =~ "Dialyzer, or how I learned to stop worrying"
  end

  test "GET post", %{conn: conn} do
    conn = get(conn, Routes.post_path(conn, :show, "3-bad-args-against-tests"))
    assert html_response(conn, 200) =~ "3 Bad Arguments Against Writing Tests"

    assert html_response(conn, 200) =~
             "Are you struggling with that one person who resists writing tests at every turn?"

    assert html_response(conn, 200) =~ "Without further ado"
  end

  test "GET rss", %{conn: conn} do
    conn = get(conn, Routes.post_path(conn, :rss))
    assert response(conn, 200) =~ "<title>Alan Vardy's Blog</title>"
  end
end
