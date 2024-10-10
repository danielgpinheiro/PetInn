defmodule PetInnWeb.Shared.Checkin.Steps.PetComponent do
  use PetInnWeb, :live_component

  def render(assigns) do
    ~H"""
  	<p>Pet</p>
    """
  end

  def mount(socket) do
    {:ok, socket}
  end
end
