defmodule PetInnWeb.Shared.Confirm.Steps.ConfirmationComponent do
  use PetInnWeb, :live_component

  def render(assigns) do
    ~H"""
    <div class="w-full sm:w-[400px] flex flex-col justify-center items-center mx-auto">
      <.icon name="hero-check-badge-solid" class="w-60 h-60 text-green-600" />
      <h1 class="text-center text-lg text-gray-800 mb-11">
        Prontinho! A estadia do Pet foi confirmada com sucesso! Estamos te esperando!
      </h1>
    </div>
    """
  end

  def mount(socket) do
    {:ok, socket}
  end
end
