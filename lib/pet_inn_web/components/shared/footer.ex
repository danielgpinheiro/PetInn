defmodule PetInnWeb.Shared.FooterComponent do
  use PetInnWeb, :live_component

  def render(assigns) do
    ~H"""
    <footer class="text-gray-500 dark:text-gray-200 relative p-3 pb-8 flex justify-between">
      <div>
        <button class="link">contato@petinns.com.br</button> <br /><small> www.petinns.com.br </small>
        <br /><small> © 2024 PetInns. All rights reserved. </small>
      </div>
      
      <div class="flex flex-col justify-center">
        <img src="/images/powered_by.jpg" class="w-40" />
      </div>
      
      <div class="flex items-center justify-center absolute bottom-2 w-full text-[9px]">
        Made with <.icon name="hero-heart-solid" class="text-gray-500 w-3 h-3 mx-[2px]" /> by
        <.icon name="hero-puzzle-piece-solid" class="text-gray-500 w-3 h-3 mx-[2px]" />
      </div>
    </footer>
    """
  end

  def mount(socket) do
    {:ok, socket}
  end
end
