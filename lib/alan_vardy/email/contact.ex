defmodule AlanVardy.Email.Contact do
  @moduledoc """
  Contact form email to be sent to admin
  """

  alias AlanVardy.Email.Content
  import Ecto.Changeset

  @required [:from_email, :name, :subject, :message]
  @cast [:answer, :not_a_robot | @required]
  @message "Message needs to be between 10 and 1000 characters"

  @doc "Ensure that data is valid before sending"
  @spec changeset(map) :: Ecto.Changeset.t()
  def changeset(attrs) do
    {%Content{}, Content.types()}
    |> cast(attrs, @cast)
    |> validate_required(@required, message: "This box must not be empty!")
    |> validate_length(:message, min: 10, max: 1000, message: @message)
  end
end
