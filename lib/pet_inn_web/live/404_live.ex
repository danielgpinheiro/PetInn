defmodule PetInnWeb.FourOhFourLive do
  @moduledoc false
  use PetInnWeb, :live_view

  def render(assigns) do
    ~H"""
    <p>Não encontrado</p>
    """
  end

  def mount(_, socket) do
    {:ok, socket}
  end
end
