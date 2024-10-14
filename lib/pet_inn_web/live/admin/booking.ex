defmodule PetInnWeb.Admin.BookingLive do
  use PetInnWeb, :live_view

  def render(assigns) do
    ~H"""
    <section class="w-full h-full overflow-hidden" phx-hook="Gantt" id="booking">
      <header
        class="w-full h-12 border-b-[1px] border-gray-300 flex items-center justify-between px-2"
        id="gantt-datepicker"
        phx-hook="GanttDatePicker"
      >
        <input
          id="datepicker"
          class="input input-bordered cursor-pointer h-8"
          placeholder="Selecionar Data"
        />
        <div class="flex items-center">
          <label class="input input-bordered flex items-center gap-2 h-8 mr-4">
            Pesquisar <input type="text" class="grow" placeholder="" />
          </label>
          
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
              Hospedagem
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
        Lorem, ipsum dolor sit amet consectetur adipisicing elit. Laboriosam, quaerat dolorem, nisi consequatur reprehenderit sapiente porro aut unde eius laudantium, architecto aspernatur possimus. Pariatur, eaque dignissimos! Nobis consequuntur in a?
      </div>
    </section>
    """
  end

  def mount(params, _session, socket) do
    locale = Map.fetch(params, "locale")

    case locale do
      {:ok, value} -> Gettext.put_locale(value)
      :error -> Gettext.put_locale("pt_BR")
    end

    {:ok, socket}
  end
end
