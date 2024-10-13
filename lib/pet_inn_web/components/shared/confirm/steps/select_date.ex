defmodule PetInnWeb.Shared.Confirm.Steps.SelectDateComponent do
  use PetInnWeb, :live_component

  alias PetInnWeb.Shared.Wizard.WizardStructureComponent

  def render(assigns) do
    ~H"""
    <div
      class="w-full sm:w-[600px] mx-auto flex flex-col justify-center"
      id="select_date"
      phx-hook="ConfirmDatePicker"
    >
      <h1 class="text-center text-lg text-gray-800 mb-11">
        <%= gettext("Por favor, selecione a data e o horário de Check-In e Check-Out do seu Pet") %>
      </h1>
      
      <input
        id="datepicker"
        class="input input-bordered cursor-pointer mx-auto w-full sm:w-[60%]"
        placeholder="Clique aqui para selecionar"
      />
    </div>
    """
  end

  def mount(socket) do
    {:ok, socket}
  end

  def update(%{action: :submit}, socket) do
    IO.inspect("opa submeti")

    send_update(WizardStructureComponent, %{id: :wizard, action: :can_continue})

    {:ok, socket}
  end

  def update(_, socket) do
    {:ok, socket}
  end
end
