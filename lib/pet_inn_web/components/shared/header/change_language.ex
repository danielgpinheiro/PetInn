defmodule PetInnWeb.Shared.Header.ChangeLanguage do
  use PetInnWeb, :live_component

  alias Phoenix.LiveView.JS

  def render(assigns) do
    ~H"""
    <div>
      <button
        class="absolute top-0 h-full right-2 sm:right-6 flex justify-between items-center w-16"
        phx-click={toggle_modal()}
      >
        <.icon name="hero-globe-alt" class="text-gray-600 sm:w-6 sm:h-6 w-4 h-4" />
        <span class="text-gray-400">PT</span>
        <.icon name="hero-chevron-down" class="text-gray-600 w-4 h-4" />
      </button>
      
      <div
        phx-click={toggle_modal()}
        class="fixed z-40 w-full h-full bg-black bg-opacity-20 top-0 left-0 hidden cursor-pointer"
        id="language-modal-overlay"
      />
      <div
        class="fixed z-50 w-[700px] h-40 rounded-lg bg-slate-50 bottom-6 left-[calc(50%-350px)] shadow overflow-hidden hidden"
        id="language-modal"
      >
        <div class="w-full h-12 bg-slate-200 flex px-3 justify-between items-center">
          <span class="text-slate-500">Mudar lingua</span>
          <button
            phx-click={toggle_modal()}
            class="px-3 py-2 rounded-full bg-slate-300 text-slate-500"
          >
            Fechar
          </button>
        </div>
        
        <ul class="w-full h-28 flex justify-center items-center">
          <li class="w-1/4 mr-4 max-w-60">
            <button class="flex w-full h-8 justify-center items-center bg-slate-200 rounded">
              <span class="text-lg mr-2">🇧🇷</span> <span>Português</span>
            </button>
          </li>
          
          <li class="w-1/4 mr-4 max-w-60">
            <button class="flex w-full h-8 justify-center items-center bg-slate-200 rounded">
              <span class="text-lg mr-2">🇺🇸</span> <span>Inglês</span>
            </button>
          </li>
          
          <li class="w-1/4 max-w-60">
            <button class="flex w-full h-8 justify-center items-center bg-slate-200 rounded">
              <span class="text-lg mr-2">🇪🇸</span> <span>Espanhol</span>
            </button>
          </li>
        </ul>
      </div>
    </div>
    """
  end

  def mount(socket) do
    {:ok, socket}
  end

  def toggle_modal(js \\ %JS{}) do
    js
    |> JS.toggle(
      to: "#language-modal",
      in: {"ease-out duration-300", "opacity-0 translate-y-full", "opacity-100 translate-y-0"},
      out: {"ease-in duration-300", "opacity-100 translate-y-0", "opacity-0 translate-y-full"}
    )
    |> JS.toggle(
      to: "#language-modal-overlay",
      in: {"ease-out duration-150", "opacity-0", "opacity-100"},
      out: {"ease-out duration-150", "opacity-100", "opacity-0"}
    )
  end
end
