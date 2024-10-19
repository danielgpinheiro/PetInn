defmodule PetInnWeb.Admin.BookingLive do
  use PetInnWeb, :live_view

  alias PetInnWeb.Shared.Admin.Booking.DetailedBooking

  def render(assigns) do
    ~H"""
    <section class="w-full h-full overflow-hidden flex flex-col" id="booking">
      <header class="w-full h-12 border-b-[1px] border-gray-300 dark:border-gray-900 flex items-center justify-between px-2">
        <label class="input input-bordered flex items-center gap-2 h-8 mr-4 dark:text-gray-200">
          Pesquisar <input type="text" class="grow rounded dark:bg-gray-900" placeholder="" />
        </label>
        
        <div class="flex items-center">
          <.dropdown label="Espécie" class="mr-4">
            <.dropdown_menu_item link_type="button" label="Cachorro" />
            <.dropdown_menu_item link_type="button" label="Gato" />
          </.dropdown>
          
          <.dropdown label="Tipo">
            <.dropdown_menu_item link_type="button" label="Check-in" />
            <.dropdown_menu_item link_type="button" label="Check-out" />
          </.dropdown>
        </div>
      </header>
      
      <div class="w-full h-full flex overflow-y-auto">
        <div id="calendar" class="w-full h-full" phx-hook="Calendar" />
      </div>
      
      <.live_component
        module={DetailedBooking}
        id={:detailed_booking}
        opened={@detailed_opened}
        params={@detailed_params}
      />
    </section>
    """
  end

  def mount(params, _session, socket) do
    locale = Map.fetch(params, "locale")

    case locale do
      {:ok, value} -> Gettext.put_locale(value)
      :error -> Gettext.put_locale("pt_BR")
    end

    {:ok, socket |> assign(detailed_opened: false, detailed_params: nil)}
  end

  def handle_event("open_detailed_booking", params, socket) do
    {:noreply, socket |> assign(detailed_params: params) |> assign(detailed_opened: true)}
  end
end
