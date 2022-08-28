defmodule AlanVardy.EmailBuilder do
  @moduledoc """
  Uses the passed in map to build an email that can be sent by the Swoop mailer
  """
  import Swoosh.Email

  @doc "Create an email struct which can sent by mailer"
  @spec create_email(%{
          from_email: String.t(),
          message: String.t(),
          name: String.t(),
          subject: String.t()
        }) :: Swoosh.Email.t()
  def create_email(%{from_email: from_email, name: name, subject: subject, message: message}) do
    new()
    |> to({"Alan", "alan@vardy.cc"})
    |> from({name, from_email})
    |> subject(subject)
    |> html_body("<h1>#{message}</h1>")
    |> text_body("#{message}\n")
  end
end
