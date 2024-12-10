defmodule PetInnWeb.Shared.Checkin.Steps.ConfirmationComponent do
  @moduledoc false
  use PetInnWeb, :live_component

  alias PetInnWeb.CheckinController
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

  def update(%{inn: inn, user_email: user_email}, socket) do
    # user = CheckinController.get_table_cache(:user, user_email)
    user = %{
      id: "d6601281-f034-48aa-b384-f9d9195093c2",
      name: "Teste 123",
      address: %{
        code: "38405056",
        state: "MG",
        number: "610",
        street: "Av Italia",
        neighborhood: "Tibery",
        country: "BR",
        complement: "AP 105",
        city: "Uberlândia"
      },
      inserted_at: ~U[2024-10-14 22:12:41Z],
      email: "dedelabritos@gmail.com",
      updated_at: ~U[2024-10-14 22:12:41Z],
      phone: "+5534999078965",
      job: "Developer",
      gender: "Masculino",
      birthday: "1995-08-31",
      pets: [
        %{
          id: nil,
          name: "Sonic",
          specie: "Cachorro",
          race: "Golden Retriever",
          is_natural_food: true,
          notes: "Ele é muito fofinho",
          photo:
            "https://diordogs.com.br/wp-content/uploads/2024/02/Imagem-do-WhatsApp-de-2024-02-08-as-21.15.06_a6fea464-768x1024.jpg",
          vaccination_card:
            "https://diordogs.com.br/wp-content/uploads/2024/02/Imagem-do-WhatsApp-de-2024-02-08-as-21.15.06_a6fea464-768x1024.jpg",
          food_hours: [
            %{
              id: nil,
              hour: "12:00"
            },
            %{
              id: nil,
              hour: "18:00"
            }
          ],
          medicines: [
            %{
              id: nil,
              name: "Remédinho Brabo",
              hours: "18:00"
            },
            %{
              id: nil,
              name: "Top Dog",
              hours: "13:00"
            }
          ]
        },
        %{
          id: nil,
          name: "abc",
          specie: "Cachorro",
          race: "ade",
          is_natural_food: false,
          notes: nil,
          photo: nil,
          vaccination_card: nil,
          food_hours: [
            %{
              id: nil,
              hour: nil
            }
          ],
          medicines: [
            %{
              id: nil,
              name: nil,
              hours: nil
            }
          ]
        }
      ]
    }

    case CheckinController.save_user(user) do
      {:error} ->
        {:ok, assign(socket, loading: false, error: true)}

      {:ok} ->
        # case CheckinController.send_confirmation_email(user, inn) do
        #   {:ok} -> {:ok, assign(socket, loading: false)}
        #   {:error} -> {:ok, assign(socket, loading: false, error: true)}
        # end
        {:ok, assign(socket, loading: false)}
    end
  end

  def update(_, socket) do
    {:ok, socket}
  end
end
