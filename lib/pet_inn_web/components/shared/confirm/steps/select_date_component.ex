defmodule PetInnWeb.Shared.Confirm.Steps.SelectDateComponent do
  @moduledoc false
  use PetInnWeb, :live_component

  alias PetInnWeb.BookingController
  alias PetInnWeb.PetController
  alias PetInnWeb.Shared.Wizard.WizardStructureComponent

  def render(assigns) do
    ~H"""
    <div id="select-date" class="w-full sm:w-[600px] mx-auto">
      <div :if={@error} class="w-full flex flex-col justify-center items-center">
        <.icon name="hero-x-circle" class="w-60 h-60 text-red-500" />
        <h1 class="text-center text-lg text-gray-800 dark:text-gray-200 mb-11">
          <%= gettext("Ocorreu um erro inesperado, tente por favor novamente!") %>
        </h1>
        <.button phx-click={JS.navigate("")} color="light" label="Recarregar página" />
      </div>

      <div :if={!@error} class="w-full flex flex-col justify-center">
        <h1 class="text-center text-lg text-gray-800 dark:text-gray-200 mb-11">
          <%= gettext(
            "Por favor, selecione quais Pets você quer reservar a estadia, e a data e o horário de Check-In e Check-Out"
          ) %>
        </h1>

        <div
          class="pc-form-field-wrapper mx-auto w-full sm:w-[60%]"
          id="datepicker-container"
          phx-hook="ConfirmDatePicker"
        >
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

        <div :if={@pets.loading} class="w-full flex justify-center items-center">
          <.spinner size="sm" class="text-primary-500" />
        </div>

        <div :if={@pets.ok? && @pets.result} class="mt-10 mb-10 w-full">
          <h3 class="pc-label">
            <%= gettext("Pets") %>
          </h3>

          <ul class="w-full flex flex-wrap sm:flex-row flex-col justify-center items-center">
            <li :for={pet <- @pets.result} class="w-64 sm:mr-4 mb-4">
              <button
                class={
              "
                flex p-4 text-left w-full rounded-md shadow-sm relative
                #{
                  if Enum.find_index(@selected_pets, fn x -> x === pet.id end) !== nil
                  do "border-[2px] border-green-500"
                  else "border-[1px] border-gray-300 dark:border-gray-600"
                  end
                }
              "
              }
                phx-click="select_pet"
                phx-target={@myself}
                phx-value-id={pet.id}
              >
                <.icon
                  :if={Enum.find_index(@selected_pets, fn x -> x === pet.id end) !== nil}
                  name="hero-check-circle-solid"
                  class="h-8 w-8 bg-green-500 absolute top-[-20px] right-[-20px]"
                />

                <img :if={pet.photo} src={pet.photo} class="w-12 h-12 rounded-full object-cover mr-4" />

                <div
                  :if={!pet.photo}
                  class="w-12 h-12 rounded-full mr-4 bg-orange-100 text-orange-600 flex justify-center items-center text-lg font-bold uppercase"
                >
                  <%= String.first(pet.name) %>
                </div>

                <div class="text-gray-800 dark:text-gray-200 flex flex-col">
                  <strong><%= pet.name %></strong>
                  <span><%= pet.race %></span>
                </div>
              </button>
            </li>
          </ul>
        </div>

        <.button
          disabled={length(@selected_pets) === 0 || @selected_date === ""}
          color="warning"
          label={gettext("Confirmar")}
          variant="shadow"
          class="mt-12 w-64 mx-auto"
          phx-click="submit"
          phx-target={@myself}
        />
      </div>
    </div>
    """
  end

  def mount(socket) do
    {:ok, assign(socket, selected_pets: [], selected_date: "", error: false)}
  end

  def update(%{inn: inn, user: user, booking: _booking, user_email: _user_email}, socket) do
    user_id = user.id

    booked_dates = BookingController.get_full_booked_days_reservations(inn.id)

    {:ok,
     push_event(
       socket
       |> assign(inn: inn, user: user)
       |> assign_async(:pets, fn -> {:ok, %{pets: PetController.get_pets(user_id)}} end),
       "set_booked_dates",
       %{dates: booked_dates}
     )}
  end

  def update(_, socket) do
    {:ok, socket}
  end

  def handle_event("select_pet", %{"id" => id}, socket) do
    old_selected_pets = socket.assigns.selected_pets

    new_selected_pets =
      if Enum.find(old_selected_pets, fn x -> x === id end) === nil,
        do: Enum.concat(old_selected_pets, [id]),
        else: List.delete(old_selected_pets, id)

    {:noreply, assign(socket, selected_pets: new_selected_pets)}
  end

  def handle_event("submit", _, socket) do
    case BookingController.create_booking(%{
           start: socket.assigns.selected_date["start"],
           end: socket.assigns.selected_date["end"],
           pet_id: socket.assigns.selected_pets,
           inn_id: socket.assigns.inn.id
         }) do
      {:error, _} ->
        {:noreply, assign(socket, error: true)}

      {:ok} ->
        send_update(WizardStructureComponent, %{
          id: :wizard,
          action: :can_continue
        })

        {:noreply, assign(socket, loading: true)}
    end
  end

  def handle_event("set_selected_date", params, socket) do
    {:noreply, assign(socket, selected_date: params)}
  end
end
