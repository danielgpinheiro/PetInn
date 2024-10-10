defmodule PetInnWeb.Shared.HeaderComponent do
  use PetInnWeb, :live_component

  def render(assigns) do
    ~H"""
    <header class="w-full h-16 flex justify-center items-center relative">
      <img
        src="/images/logo_inn.png"
        class="absolute top-1/4 left-6 h-full max-h-20 mt-[-10px]"
        alt="logo"
      />
      <div class="w-8 h-full relative flex justify-center items-center">
        <span class="text-lg font-semibold tracking-tight text-orange-400 whitespace-nowrap absolute top-0 right-8 leading-[60px]">
          Pet Check-in Online
        </span>
         <div class="w-[1px] h-8 bg-gray-300" />
        <span class="text-lg font-semibold tracking-tight text-orange-400 whitespace-nowrap absolute top-0 left-8 leading-[60px]">
          Santo Chico
        </span>
      </div>
      
      <button class="absolute top-0 h-full right-6 flex justify-between items-center w-16">
        <.icon name="hero-globe-alt" class="text-gray-600" /> <span class="text-gray-400">PT</span>
        <.icon name="hero-chevron-down" class="text-gray-600 w-4 h-4" />
      </button>
    </header>
    """
  end

  def mount(socket) do
    {:ok, socket}
  end
end
