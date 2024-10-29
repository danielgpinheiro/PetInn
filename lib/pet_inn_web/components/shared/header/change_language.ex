defmodule PetInnWeb.Shared.Header.ChangeLanguage do
  @moduledoc false
  use PetInnWeb, :live_component
  use Gettext, backend: PetInnWeb.Gettext

  alias Phoenix.LiveView.JS

  def render(assigns) do
    ~H"""
    <div id="change-language" phx-hook="Locale">
      <button
        class="absolute top-0 h-full right-2 sm:right-6 flex justify-between items-center w-12"
        phx-click={toggle_modal()}
        data-tippy-content={gettext("Mudar Lingua")}
        data-tippy-placement="bottom"
      >
        <.icon name="hero-globe-alt" class="text-gray-600 dark:text-gray-200 sm:w-6 sm:h-6 w-4 h-4" />
        <span class="text-gray-400 dark:text-gray-200 uppercase">
          <%= String.replace(Gettext.get_locale(), "_BR", "") %>
        </span>
      </button>

      <div
        phx-click={toggle_modal()}
        class="fixed z-40 w-full h-full bg-black bg-opacity-20 top-0 left-0 hidden cursor-pointer"
        id="language-modal-overlay"
      />
      <div
        class="fixed z-50 w-[700px] h-40 rounded-lg bg-slate-50 dark:bg-gray-700 bottom-6 left-[calc(50%-350px)] shadow overflow-hidden hidden"
        id="language-modal"
      >
        <div class="w-full h-12 bg-slate-200 dark:bg-gray-800 flex px-3 justify-between items-center">
          <span class="text-slate-500 dark:text-gray-200"><%= gettext("Mudar lingua") %></span>
          <button
            phx-click={toggle_modal()}
            class="px-3 py-2 rounded-full bg-slate-300 text-slate-500 dark:text-gray-200 dark:bg-gray-700"
          >
            <%= gettext("Fechar") %>
          </button>
        </div>

        <ul class="w-full h-28 flex justify-center items-center">
          <li class="w-1/4 mr-4 max-w-60">
            <button
              class="flex w-full h-8 justify-center items-center bg-slate-200 dark:bg-gray-800 rounded"
              phx-click="change_lang"
              phx-target={@myself}
              phx-value-lang="pt_BR"
            >
              <span class="text-lg mr-2">🇧🇷</span>
              <span class="dark:text-gray-200"><%= gettext("Português") %></span>
            </button>
          </li>

          <li class="w-1/4 mr-4 max-w-60">
            <button
              class="flex w-full h-8 justify-center items-center bg-slate-200 dark:bg-gray-800 rounded"
              phx-click="change_lang"
              phx-target={@myself}
              phx-value-lang="en"
            >
              <span class="text-lg mr-2">🇺🇸</span>
              <span class="dark:text-gray-200"><%= gettext("Inglês") %></span>
            </button>
          </li>

          <li class="w-1/4 max-w-60">
            <button
              class="flex w-full h-8 justify-center items-center bg-slate-200 dark:bg-gray-800 rounded"
              phx-click="change_lang"
              phx-target={@myself}
              phx-value-lang="es"
            >
              <span class="text-lg mr-2">🇪🇸</span>
              <span class="dark:text-gray-200"><%= gettext("Espanhol") %></span>
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

  def handle_event("change_lang", %{"lang" => lang}, socket) do
    {:noreply,
     push_event(
       socket,
       "save_locale",
       %{locale: lang}
     )}
  end
end
