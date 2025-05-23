defmodule PetInnWeb.Shared.Checkout.Steps.ReviewComponent do
  @moduledoc false
  use PetInnWeb, :live_component

  alias PetInnWeb.Shared.Wizard.WizardStructureComponent

  def render(assigns) do
    ~H"""
    <div class="w-full sm:w-[600px] flex flex-col justify-center items-center mx-auto">
      <h1 class="text-center text-lg text-gray-800 dark:text-gray-200 mb-11">
        Como foi a estadia do seu Pet? Queremos saber como foi a experiência!
      </h1>

      <ul class="w-full flex justify-center mb-12">
        <li class="w-10 h-10 rounded text-white bg-red-800 mr-2">
          <button class="w-full h-full flex justify-center items-center">0</button>
        </li>

        <li class="w-10 h-10 rounded text-white bg-red-700 mr-2">
          <button class="w-full h-full flex justify-center items-center">1</button>
        </li>

        <li class="w-10 h-10 rounded text-white bg-orange-600 mr-2">
          <button class="w-full h-full flex justify-center items-center">2</button>
        </li>

        <li class="w-10 h-10 rounded text-white bg-orange-500 mr-2">
          <button class="w-full h-full flex justify-center items-center">3</button>
        </li>

        <li class="w-10 h-10 rounded text-white bg-orange-400 mr-2">
          <button class="w-full h-full flex justify-center items-center">4</button>
        </li>

        <li class="w-10 h-10 rounded text-white bg-yellow-400 mr-2">
          <button class="w-full h-full flex justify-center items-center">5</button>
        </li>

        <li class="w-10 h-10 rounded text-white bg-yellow-300 mr-2">
          <button class="w-full h-full flex justify-center items-center">6</button>
        </li>

        <li class="w-10 h-10 rounded text-white bg-lime-300 mr-2">
          <button class="w-full h-full flex justify-center items-center">7</button>
        </li>

        <li class="w-10 h-10 rounded text-white bg-lime-400 mr-2">
          <button class="w-full h-full flex justify-center items-center">8</button>
        </li>

        <li class="w-10 h-10 rounded text-white bg-lime-500 mr-2">
          <button class="w-full h-full flex justify-center items-center">9</button>
        </li>

        <li class="w-10 h-10 rounded text-white bg-green-600 mr-2">
          <button class="w-full h-full flex justify-center items-center">10</button>
        </li>
      </ul>

      <div class="pc-form-field-wrapper w-full">
        <label class="pc-label">
          <%= gettext("Observações") %>
        </label>

        <textarea class="w-full pc-text-input"></textarea>
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

  def update(%{inn: _inn, user: _user, booking: booking, user_email: _user_email}, socket) do
    IO.inspect(booking)

    {:ok, socket}
  end

  def handle_event("submit", _, socket) do
    send_update(WizardStructureComponent, %{
      id: :wizard,
      action: :can_continue
    })

    {:noreply, assign(socket, loading: true)}
  end

  def update(_, socket) do
    {:ok, socket}
  end
end
