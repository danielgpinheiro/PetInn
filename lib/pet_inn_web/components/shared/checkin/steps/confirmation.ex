defmodule PetInnWeb.Shared.Checkin.Steps.ConfirmationComponent do
  @moduledoc false
  use PetInnWeb, :live_component

  alias PetInnWeb.CheckinController

  def render(assigns) do
    ~H"""
    <div class="w-full h-full border-[1px] border-red-500">
      <%= if @loading do %>
        <div class="w-full sm:w-[400px] flex flex-col justify-center items-center mx-auto">
          <h1 class="text-center text-lg text-gray-800 dark:text-gray-200 mb-11">
            <%= gettext(
              "Estamos guardando as suas informações com segurança. Por favor, não feche essa janela até tudo ficar pronto."
            ) %>
          </h1>
        </div>
      <% else %>
        <div class="w-full sm:w-[400px] flex flex-col justify-center items-center mx-auto">
          <.icon name="hero-check-circle-solid" class="w-60 h-60 text-green-600" />
          <h1 class="text-center text-lg text-gray-800 mb-11">
            <%= gettext(
              "Enviamos para o seu email um link de confirmação da estadia, por favor verifique na sua caixa de entrada ou span."
            ) %>
          </h1>
        </div>
      <% end %>
    </div>
    """
  end

  def mount(socket) do
    {:ok, assign(socket, loading: true, error: false)}
  end

  def update(%{inn: inn, user_email: user_email}, socket) do
    # user = CheckinController.get_table_cache(:user, user_email)

    # IO.inspect(user)
    # IO.inspect(inn)

    {:ok, socket}
  end

  def update(_, socket) do
    {:ok, socket}
  end
end
