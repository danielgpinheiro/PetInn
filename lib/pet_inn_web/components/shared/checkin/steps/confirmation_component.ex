defmodule PetInnWeb.Shared.Checkin.Steps.ConfirmationComponent do
  @moduledoc false
  use PetInnWeb, :live_component

  alias PetInnWeb.CheckinController
  alias PetInnWeb.UserController
  alias PetInnWeb.Utils.EtsUtils
  alias Phoenix.LiveView.JS

  def render(assigns) do
    ~H"""
    <div class="w-full h-full" id="confirmation-step" phx-hook="Lottie">
      <%= cond do %>
        <% !@loading and @error -> %>
          <div class="w-full sm:w-[400px] flex flex-col justify-center items-center mx-auto">
            <.icon name="hero-x-circle" class="w-60 h-60 text-red-500" />
            <h1 class="text-center text-lg text-gray-800 dark:text-gray-200 mb-11">
              <%= gettext("Ocorreu um erro inesperado, tente por favor novamente!") %>
            </h1>
            <.button phx-click={JS.navigate("")} color="light" label="Recarregar página" />
          </div>
        <% @loading -> %>
          <div class="w-full sm:w-[400px] flex flex-col justify-center items-center mx-auto">
            <h1 class="text-center text-lg text-gray-800 dark:text-gray-200">
              <%= gettext(
                "Estamos processando as suas informações com segurança. Por favor, não feche essa janela até tudo ficar pronto."
              ) %>
            </h1>
            <div data-lottie="running-dog" class="w-96 mt-[-45px]" />
          </div>
        <% !@loading -> %>
          <div class="w-full sm:w-[400px] flex flex-col justify-center items-center mx-auto">
            <.icon name="hero-check-circle-solid" class="w-60 h-60 text-green-600" />
            <h1 class="text-center text-lg text-gray-800 dark:text-gray-200 mb-11">
              <%= gettext(
                "Enviamos para o seu email um link de confirmação da estadia, por favor verifique na sua caixa de entrada ou spam."
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

  def update(%{inn: inn, user: _user, user_email: user_email}, socket) do
    user = EtsUtils.get_table_cache(:user, user_email)

    case UserController.save_user(user) do
      {:error} ->
        {:ok, assign(socket, loading: false, error: true)}

      {:ok} ->
        case CheckinController.send_confirmation_email(user, inn) do
          {:ok} -> {:ok, assign(socket, loading: false)}
          {:error} -> {:ok, assign(socket, loading: false, error: true)}
        end
    end
  end

  def update(_, socket) do
    {:ok, socket}
  end
end
