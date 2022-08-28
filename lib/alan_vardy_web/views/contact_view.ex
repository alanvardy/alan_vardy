defmodule AlanVardyWeb.ContactView do
  @moduledoc false
  use AlanVardyWeb, :view

  @doc "Renders the captcha image"
  @spec display_captcha(binary) :: {:safe, iolist}
  def display_captcha(captcha_image) do
    content_tag(:img, "", src: "data:image/png;base64," <> captcha_image)
  end
end
