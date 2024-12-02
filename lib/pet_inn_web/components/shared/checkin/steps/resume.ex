defmodule PetInnWeb.Shared.Checkin.Steps.ResumeComponent do
  @moduledoc false
  use PetInnWeb, :live_component

  alias PetInnWeb.CheckinController
  alias PetInnWeb.Shared.Wizard.WizardStructureComponent

  def render(assigns) do
    ~H"""
    <div class="w-full sm:w-[600px] flex flex-col justify-center mx-auto">
      <h1 class="text-center text-lg text-gray-800 dark:text-gray-200 mb-11">
        Confira se todos os dados estão corretos, caso não, é possivel edita-los no botão Editar Informações
      </h1>

      <div class="w-full flex justify-between mb-12 flex-wrap">
        <div class="w-full sm:w-[49%] mb-2">
          <.card>
            <.card_content category={gettext("Dados Pessoais")}>
              <span><strong>Email:</strong> <%= @user.email %></span>
              <br />
              <span><strong>Telefone:</strong> <%= @user.phone %></span>
              <br />
              <span><strong>Nome Completo:</strong> <%= @user.name %></span>
              <br />
              <span><strong>Data de Nascimento:</strong> <%= @user.birthday %></span>
              <br />
              <span><strong>Gênero:</strong> <%= @user.gender %></span>
              <br />
              <span><strong>Profissão:</strong> <%= @user.job %></span>
              <br /><br />
              <hr />
              <br />
              <span><strong>CEP:</strong> <%= @user.address.code %></span>
              <br />
              <span><strong>País:</strong> <%= @user.address.country %></span>
              <br />
              <span><strong>Estado:</strong> <%= @user.address.state %></span>
              <br />
              <span><strong>Cidade:</strong> <%= @user.address.city %></span>
              <br />
              <span><strong>Bairro:</strong> <%= @user.address.neighborhood %></span>
              <br />
              <span><strong>Logradouro:</strong> <%= @user.address.street %></span>
              <br />
              <span><strong>Número:</strong> <%= @user.address.number %></span>
              <br />
              <span><strong>Complemento:</strong> <%= @user.address.complement %></span>
            </.card_content>
          </.card>
        </div>

        <div :for={pet <- @user.pets.pets} class="w-full sm:w-[49%] mb-2">
          <.card>
            <.card_content category={gettext("Dados do Pet")}>
              <span><strong>Nome:</strong> <%= pet.name %></span>
              <br />
              <span><strong>Espécie:</strong> <%= pet.specie %></span>
              <br />
              <span><strong>Raça:</strong> <%= pet.race %></span>
              <br />
              <span><strong>Alimentação:</strong> Lista</span>
              <br />
              <span>
                <strong>Comida Natural:</strong> <%= if pet.is_natural_food,
                  do: gettext("Sim"),
                  else: gettext("Não") %>
              </span>
              <br />
              <span><strong>Remédios:</strong> Lista</span>
              <br />
              <span><strong>Observações:</strong> <%= pet.notes %></span>
            </.card_content>
          </.card>
        </div>
      </div>

      <div class="w-full mb-20">
        <.card>
          <.card_content category={gettext("Endereço do ") <> @inn.name}>
            <p><%= @inn.address %></p>
            <span><strong>Check-In: </strong><%= @inn.checkin_hour %></span>
            <span><strong>Check-Out: </strong><%= @inn.checkout_hour %></span>
            <span>
              <strong><%= gettext("Valor da Diária: ") %> </strong>R$ <%= @inn.diary_price %>
            </span>
          </.card_content>
          <.card_footer>
            <iframe
              src={@inn.maps_URL}
              width="100%"
              height="450"
              style="border:0;"
              allowfullscreen=""
              loading="lazy"
              referrerpolicy="no-referrer-when-downgrade"
            >
            </iframe>
          </.card_footer>
        </.card>
      </div>

      <.button
        color="white"
        variant="outline"
        class="w-64 mx-auto"
        phx-target={@myself}
        phx-click="edit"
      >
        <%= gettext("Editar Informações") %>
      </.button>

      <.button
        color="warning"
        label={gettext("Continuar")}
        variant="shadow"
        class="mt-12 w-64 mx-auto"
        phx-target={@myself}
        phx-click="submit"
      />
    </div>
    """
  end

  def mount(socket) do
    {:ok, socket}
  end

  def update(%{inn: inn, user_email: user_email}, socket) do
    user = CheckinController.get_table_cache(:user, user_email)

    {:ok, assign(socket, inn: inn, user: user)}
  end

  def update(_, socket) do
    {:ok, socket}
  end

  def handle_event("edit", _, socket) do
    send_update(WizardStructureComponent, %{id: :wizard, action: :go_to_step, step: "0"})

    {:noreply, push_event(socket, "scroll_to_element", %{element: "body", top: 0, left: 0, behavior: "instant", c: true})}
  end

  def handle_event("submit", _, socket) do
    send_update(WizardStructureComponent, %{
      id: :wizard,
      action: :can_continue
    })

    {:noreply, socket}
  end
end
