defmodule PetInnWeb.AdminLayout do
  @moduledoc false
  use PetInnWeb, :live_view

  alias PetInnWeb.Shared.Header.ChangeLanguage
  alias PetInnWeb.Shared.Header.ThemeSelector
  alias Phoenix.LiveView.JS

  def render(assigns) do
    ~H"""
    <main class="w-full h-screen bg-slate-50 dark:bg-gray-800" id="main" phx-hook="Tooltip">
      <div id="scroll-to-element" class="w-full h-full" phx-hook="ScrollToElement">
        <.flash_group flash={@flash} />
        <section class="w-full h-full flex">
          <aside
            id="navigation-drawer"
            class="w-64 h-full border-r-[1px] border-gray-300 dark:border-gray-900 shrink-0 transition-all duration-300 p-2 relative"
          >
            <img src="/images/logo_inn.png" class="w-20 mx-auto mb-20" />
            <nav class="w-full flex flex-col">
              <.link
                navigate="/admin/booking"
                class="leading-6 text-zinc-900 dark:text-gray-200 hover:text-zinc-700 hover:bg-slate-200 hover:dark:bg-gray-600 hover:dark:text-gray-200 p-2 rounded transition-colors mb-4 no-wrap"
              >
                <.icon name="hero-bars-3-bottom-left" class="mr-2" /> <%= gettext("Reservas") %>
              </.link>

              <.link
                navigate="/admin/rating"
                class="leading-6 text-zinc-900 dark:text-gray-200 hover:text-zinc-700 hover:bg-slate-200 hover:dark:bg-gray-600 hover:dark:text-gray-200 p-2 rounded transition-colors mb-4"
              >
                <.icon name="hero-star" class="mr-2" /> <%= gettext("Avaliações") %>
              </.link>

              <.link
                navigate="/admin/generate"
                class="leading-6 text-zinc-900 dark:text-gray-200 hover:text-zinc-700 hover:bg-slate-200 hover:dark:bg-gray-600 hover:dark:text-gray-200 p-2 rounded transition-colors mb-4"
              >
                <.icon name="hero-qr-code" class="mr-2" /> <%= gettext("Gerar Link de Check-In") %>
              </.link>

              <div class="absolute bottom-0 left-0 w-full p-2">
                <button class="leading-6 text-zinc-900 dark:text-gray-200 hover:text-zinc-700 hover:bg-slate-200 hover:dark:bg-gray-600 hover:dark:text-gray-200 p-2 rounded transition-colors flex items-center">
                  <.icon name="hero-power" class="mr-2" /> <%= gettext("Sair") %>
                </button>
                <.live_component module={ChangeLanguage} id={:change_language} />
                <.live_component module={ThemeSelector} id={:change_language} />
              </div>
            </nav>
          </aside>

          <div class="w-full h-full flex flex-col">
            <header class="w-full h-16 flex justify-between items-center px-4 shrink-0">
              <div class="flex items-center">
                <button
                  id="nav-toggle-button"
                  phx-click={
                    JS.toggle_class("!w-0 !p-0 opacity-0 pointer-events-none",
                      to: "#navigation-drawer"
                    )
                    |> JS.toggle_class("opened", to: "#nav-toggle-button")
                  }
                  class="text-gray-500 dark:text-gray-200 dark:hover:bg-gray-600 p-[4px] hover:bg-gray-200 rounded transition-colors mr-2"
                >
                  <svg
                    class="open-icon"
                    xmlns="http://www.w3.org/2000/svg"
                    width="24"
                    height="24"
                    viewBox="0 0 48 48"
                  >
                    <g fill="none" stroke="currentColor" stroke-linejoin="round" stroke-width="4">
                      <path d="M6 9a3 3 0 0 1 3-3h30a3 3 0 0 1 3 3v30a3 3 0 0 1-3 3H9a3 3 0 0 1-3-3z" /><path
                        stroke-linecap="round"
                        d="M32 6v36M16 20l4 4l-4 4M26 6h12M26 42h12"
                      />
                    </g>
                  </svg>

                  <svg
                    class="close-icon"
                    xmlns="http://www.w3.org/2000/svg"
                    width="24"
                    height="24"
                    viewBox="0 0 48 48"
                  >
                    <g fill="none" stroke="currentColor" stroke-linejoin="round" stroke-width="4">
                      <rect width="36" height="36" x="6" y="6" rx="3" /><path
                        stroke-linecap="round"
                        d="M18 6v36M11 6h25M11 42h25m-4-22l-4 4l4 4"
                      />
                    </g>
                  </svg>
                </button>

                <h1 class="font-medium text-[18px] text-gray-800 dark:text-gray-200">
                  Santo Chico Hotel e Pet Shop
                </h1>
              </div>
              <img src="/images/logo.jpg" class="w-11 h-11" />
            </header>

            <div class="w-full h-[calc(100%-64px)] p-2">
              <div class="w-full h-full overflow-hidden border-[1px] border-gray-300 dark:border-gray-900 bg-white dark:bg-gray-700 rounded-lg">
                <%= @inner_content %>
              </div>
            </div>
          </div>
        </section>
      </div>
    </main>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
