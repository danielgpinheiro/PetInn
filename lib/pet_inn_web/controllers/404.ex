defmodule PetInnWeb.FourOhFourController do
  use PetInnWeb, :controller

  def index(conn, _params) do
    redirect(conn, to: "/404")
  end
end
