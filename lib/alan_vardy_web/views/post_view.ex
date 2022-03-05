defmodule AlanVardyWeb.PostView do
  @moduledoc false
  use AlanVardyWeb, :view

  alias AlanVardyWeb.Paginate

  defdelegate paginate(conn, page), to: Paginate, as: :build
end
