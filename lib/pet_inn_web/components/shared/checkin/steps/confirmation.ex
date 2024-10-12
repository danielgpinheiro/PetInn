defmodule PetInnWeb.Shared.Checkin.Steps.ConfirmationComponent do
  use PetInnWeb, :live_component

  alias PetInnWeb.Shared.Wizard.WizardStructureComponent

  def render(assigns) do
    ~H"""
    <div class="w-full sm:w-[400px] flex flex-col justify-center items-center mx-auto">
      <.icon name="hero-check-circle-solid" class="w-60 h-60 text-green-600" />
      <h1 class="text-center text-lg text-gray-800 mb-11">
        Enviamos para o seu email um link de confirmação da estadia, por favor verifique na sua caixa de entrada ou span.
      </h1>
    </div>
    """
  end

  def mount(socket) do
    {:ok, socket}
  end
end
