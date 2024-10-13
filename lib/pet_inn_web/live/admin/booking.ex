defmodule PetInnWeb.Admin.BookingLive do
  use PetInnWeb, :live_view

  def render(assigns) do
    ~H"""
    <section class="w-full h-full overflow-y-auto" phx-hook="Gantt" id="booking">
      <header
        class="w-full h-12 border-b-[1px] border-gray-300 flex items-center justify-start px-2"
        id="gantt-datepicker"
        phx-hook="GanttDatePicker"
      >
        <input
          id="datepicker"
          class="input input-bordered cursor-pointer h-8"
          placeholder="Selecionar Data"
        />
      </header>
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
