defmodule PetInnWeb.CheckinLive do
  use PetInnWeb, :live_view

  def render(assigns) do
    ~H"""
    <section id="checkin">
      checkin
    </section>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
