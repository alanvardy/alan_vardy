defmodule AlanVardy.Log do
  @moduledoc "For logging to terminal"
  require Logger

  @doc "Log an error"
  @spec error(module, any) :: :ok
  def error(module, error) when is_binary(error) do
    Logger.error("[#{inspect(module)}] #{error}")
  end

  def error(module, error) do
    error(module, inspect(error))
  end
end
