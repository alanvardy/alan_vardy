defmodule AlanVardyWeb.PageControllerTest do
  use AlanVardyWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "My name is Alan Vardy, I am a Senior Developer"
  end
end
