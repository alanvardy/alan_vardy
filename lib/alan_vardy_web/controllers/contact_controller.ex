defmodule AlanVardyWeb.ContactController do
  @moduledoc false
  use AlanVardyWeb, :controller

  alias AlanVardy.Email.Contact
  alias AlanVardy.{EmailBuilder, Log, Mailer}

  @doc false
  @spec new(Plug.Conn.t(), map) :: Plug.Conn.t()
  def new(conn, _params) do
    with {captcha_text, captcha_image} <- ExRoboCop.create_captcha() do
      id = ExRoboCop.create_form_id(captcha_text)

      render(conn, "new.html",
        page_title: "Contact",
        changeset: Contact.changeset(%{}),
        id: id,
        captcha_image: captcha_image
      )
    end
  end

  @doc false
  @spec create(Plug.Conn.t(), map) :: Plug.Conn.t()
  def create(conn, %{"content" => %{"not_a_robot" => text, "form_id" => form_id} = message_params}) do
    changeset = Contact.changeset(message_params)

    with :ok <- ExRoboCop.not_a_robot?({text, form_id}),
         {:ok, content} <- Ecto.Changeset.apply_action(changeset, :insert),
         %Swoosh.Email{} = message <- EmailBuilder.create_email(content),
         {:ok, _map} <- Mailer.deliver(message) do
      conn
      |> put_flash(:info, "Your message has been sent successfully")
      |> redirect(to: Routes.page_path(conn, :index))
    else
      # Captcha text was entered incorrectly
      {:error, :wrong_captcha} ->
        render_page(
          conn,
          changeset,
          :error,
          "Your answer did not match the captcha. Please try again!"
        )

      # Failed changeset validation
      {:error, %Ecto.Changeset{} = changeset} ->
        render_page(
          conn,
          changeset,
          :error,
          "There was a problem sending your message"
        )

      # Anything else
      error ->
        Log.error(__MODULE__, error)

        conn
        |> put_flash(:error, "Something went wrong")
        |> redirect(to: Routes.contact_path(conn, :new))
    end
  end

  defp render_page(conn, changeset, message_type, message) do
    with {captcha_text, captcha_image} <- ExRoboCop.create_captcha() do
      id = ExRoboCop.create_form_id(captcha_text)

      conn
      |> put_flash(message_type, message)
      |> render("new.html",
        changeset: changeset,
        id: id,
        captcha_image: captcha_image,
        page_title: "Contact"
      )
    end
  end
end
