defmodule PetInnWeb.Shared.Confirm.Steps.SelectDateComponent do
  use PetInnWeb, :live_component

  alias PetInnWeb.Shared.Wizard.WizardStructureComponent

  def render(assigns) do
    ~H"""
    <div
      class="w-[600px] mx-auto flex flex-col justify-center"
      id="select_date"
      phx-hook="ConfirmDatePicker"
    >
      <h1 class="text-center text-lg text-gray-800 mb-11">
        <%= gettext("Por favor, selecione a data e o horário de Check-In e Check-Out do seu Pet") %>
      </h1>
      
      <div class="flex justify-between">
        <label class="form-control w-[48%]">
          <div class="label">
            <span class="label-text">Check-In</span>
          </div>
           <input type="datetime-local" placeholder="" class="input input-bordered w-full max-w-xs" />
        </label>
        
        <label class="form-control w-[48%]">
          <div class="label">
            <span class="label-text">Check-Out</span>
          </div>
           <input type="datetime-local" placeholder="" class="input input-bordered w-full max-w-xs" />
        </label>
      </div>
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
