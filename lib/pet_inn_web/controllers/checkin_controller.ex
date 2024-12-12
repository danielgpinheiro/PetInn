defmodule PetInnWeb.CheckinController do
  use PetInnWeb, :controller

  alias PetInn.Mailer

  def send_confirmation_email(user, inn) do
    case user |> Mailer.UserConfirmationEmail.confirmation(inn) |> Mailer.Adapter.deliver() do
      {:ok, _} -> {:ok}
      {_, _} -> {:error}
    end
  end
end
