defmodule PetInnWeb.Admin.RatingLive do
  use PetInnWeb, :live_view

  def render(assigns) do
    ~H"""
    <section class="w-full h-full overflow-hidden" id="rating">
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
      </header>
      
      <ul class="w-full h-full flex overflow-y-auto flex-wrap p-4">
        <li class="w-1/5 mr-[5%] mb-4">
          <div class="card bg-base-100 w-80 shadow-md">
            <div class="card-body">
              <h2 class="card-title text-sm">Sonic Golden - Daniel Pinheiro</h2>
              
              <p>NPS: 10</p>
              
              <div class="card-actions justify-start">
                Observações: loirem ipsum
              </div>
            </div>
          </div>
        </li>
      </ul>
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
