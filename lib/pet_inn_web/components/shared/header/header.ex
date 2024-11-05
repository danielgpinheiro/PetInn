defmodule PetInnWeb.Shared.Header.HeaderComponent do
  @moduledoc false
  use PetInnWeb, :live_component

  alias PetInnWeb.CheckinController
  alias PetInnWeb.Shared.Header.ChangeLanguage
  alias PetInnWeb.Shared.Header.ThemeSelector

  def render(assigns) do
    ~H"""
    <header class="w-full h-16 flex justify-center items-center relative px-2 py-2 sm:p-0 sm:border-0 border-b-[1px] border-gray-300">
      <img
        src={@logo}
        class="sm:absolute sm:top-1/4 sm:left-6 h-full max-h-20 sm:mt-[-10px]"
        alt="logo"
      />
      <div class="w-8 h-full relative justify-center items-center hidden sm:flex">
        <span class="text-lg font-semibold tracking-tight text-orange-400 whitespace-nowrap absolute top-0 right-8 leading-[60px]">
          Pet Check-in Online
        </span>
        <div class="w-[1px] h-8 bg-gray-300" />
        <span class="text-lg font-semibold tracking-tight text-orange-400 whitespace-nowrap absolute top-0 left-8 leading-[60px]">
          <%= @name %>
        </span>
      </div>
      <.live_component module={ChangeLanguage} id={:change_language} />
      <.live_component module={ThemeSelector} id={:theme_selector} />
    </header>
    """
  end

  def mount(socket) do
    {:ok, socket}
  end

  def update(%{inn_id: inn_id} = _assigns, socket) do
    inn = CheckinController.get_table_cache(:inn, inn_id)

    {:ok, socket |> assign(logo: inn.logo) |> assign(name: inn.name)}
  end
end
