defmodule AlanVardyWeb.TagControllerTest do
  use AlanVardyWeb.ConnCase

  test "GET tag", %{conn: conn} do
    conn = get(conn, Routes.tag_path(conn, :show, "elixir"))
    assert html_response(conn, 200) =~ "#elixir"
  end
end
