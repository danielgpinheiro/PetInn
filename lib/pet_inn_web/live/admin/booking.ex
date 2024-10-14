defmodule PetInnWeb.Admin.BookingLive do
  use PetInnWeb, :live_view

  alias PetInnWeb.Shared.Admin.Booking.DetailedBooking

  def render(assigns) do
    ~H"""
    <section class="w-full h-full overflow-hidden flex flex-col" id="booking">
      <header class="w-full h-12 border-b-[1px] border-gray-300 flex items-center justify-between px-2">
        <label class="input input-bordered flex items-center gap-2 h-8 mr-4">
          Pesquisar <input type="text" class="grow" placeholder="" />
        </label>
        
        <div class="flex items-center">
          <div class="dropdown dropdown-bottom dropdown-end">
            <div tabindex="0" role="button" class="btn btn-outline m-1 btn-sm">Espécie</div>
            
            <ul
              tabindex="0"
              class="dropdown-content menu bg-base-100 rounded-box z-[1] w-52 p-2 shadow"
            >
              <li><a>Cachorro</a></li>
              
              <li><a>Gato</a></li>
            </ul>
          </div>
          
          <div class="dropdown dropdown-bottom dropdown-end">
            <div tabindex="0" role="button" class="btn btn-outline m-1 btn-sm">
              <%= @detailed_opened %>
            </div>
            
            <ul
              tabindex="0"
              class="dropdown-content menu bg-base-100 rounded-box z-[1] w-52 p-2 shadow"
            >
              <li><a>Check-In</a></li>
              
              <li><a>Check-Out</a></li>
            </ul>
          </div>
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
