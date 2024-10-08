defmodule PetInnWeb.RedirectController do
  use PetInnWeb, :controller

  def index(conn, _params) do
    conn
    |> redirect(to: "/checkin")
    |> halt()
  end
end
