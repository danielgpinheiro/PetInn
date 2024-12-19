defmodule PetInnWeb.Shared.Confirm.Steps.SelectDateComponent do
  @moduledoc false
  use PetInnWeb, :live_component

  alias PetInnWeb.Shared.Wizard.WizardStructureComponent

  def render(assigns) do
    ~H"""
    <div
      class="w-full sm:w-[600px] mx-auto flex flex-col justify-center"
      id="select_date"
      phx-hook="ConfirmDatePicker"
    >
      <h1 class="text-center text-lg text-gray-800 dark:text-gray-200 mb-11">
        <%= gettext(
          "Por favor, selecione quais Pets você quer reservar a estadia, e a data e o horário de Check-In e Check-Out"
        ) %>
      </h1>

      <div class="pc-form-field-wrapper mx-auto w-full sm:w-[60%]">
        <label for="object_email" class="pc-label">
          <%= gettext("Calendário") %>
        </label>

        <input
          id="datepicker"
          class="pc-text-input"
          placeholder={gettext("Clique aqui para selecionar")}
          type="text"
        />
      </div>

      <div class="border-[1px] border-red-500 mt-10 mb-10 w-full">
        <h3 class="pc-label">
          <%= gettext("Pets") %>
        </h3>

        <ul class="border-[1px] border-green-500 w-full">
          lista de pets
        </ul>
      </div>

      <.button
        color="warning"
        label={gettext("Confirmar")}
        variant="shadow"
        class="mt-12 w-64 mx-auto"
        phx-click="submit"
        phx-target={@myself}
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

  def handle_event("submit", _, socket) do
    send_update(WizardStructureComponent, %{
      id: :wizard,
      action: :can_continue
    })

    {:noreply, assign(socket, loading: true)}
  end
end
