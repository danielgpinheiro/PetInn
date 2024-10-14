defmodule PetInnWeb.Shared.Admin.Booking.DetailedBooking do
  use PetInnWeb, :live_component

  def render(assigns) do
    ~H"""
    <aside class={"fixed z-[99] top-0 right-0 w-full h-full #{if @opened, do: "opacity-100 pointer-events-auto", else: "opacity-0 pointer-events-none"}"}>
      <div
        class={"absolute z-40 w-full h-full bg-black bg-opacity-20 top-0 left-0 cursor-pointer opacity-0 transition-opacity #{if @opened, do: "opacity-100"}"}
        id="detailed-booking-overlay"
        phx-click="close_modal"
        phx-target={@myself}
      />
      <div
        class={"absolute z-50 w-[450px] h-[calc(100%-48px)] rounded-lg bg-slate-50 top-6 right-2 shadow overflow-y-auto pt-12 translate-x-full transition-transform #{if @opened, do: "!translate-x-0"}"}
        id="detailed-booking-modal"
      >
        <div class="absolute top-0 left-0 w-full h-12 bg-slate-200 flex px-3 justify-between items-center border-b-[1px] border-slate-300">
          <span class="text-slate-500"><%= gettext("Detalhes da Reserva") %></span>
          <button
            class="px-3 py-2 rounded-full bg-slate-300 text-slate-500"
            phx-click="close_modal"
            phx-target={@myself}
          >
            <%= gettext("Fechar") %>
          </button>
        </div>
        Detalhes da Reserva XPTO
      </div>
    </aside>
    """
  end

  def mount(socket) do
    {:ok, socket |> assign(opened: false) |> assign(params: nil)}
  end

  def update(%{opened: opened, params: params} = _assigns, socket) do
    {:ok, socket |> assign(params: params) |> assign(opened: opened)}
  end

  def update(_, socket) do
    {:ok, socket}
  end

  def handle_event("close_modal", _, socket) do
    {:noreply, socket |> assign(opened: false)}
  end
end
