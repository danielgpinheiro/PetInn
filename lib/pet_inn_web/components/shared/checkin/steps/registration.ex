defmodule PetInnWeb.Shared.Checkin.Steps.RegistrationComponent do
  use PetInnWeb, :live_component

  alias PetInnWeb.CheckinController
  alias PetInnWeb.Shared.Wizard.WizardStructureComponent

  def render(assigns) do
    ~H"""
    <div class="w-full sm:w-[700px] mx-auto flex flex-col justify-center items-center relative">
      <%= if @loading do %>
        <div class="w-full h-full absolute z-50 flex justify-center items-center bg-white bg-opacity-10 rounded-lg">
          <.spinner show={true} size="lg" class="pointer-events-none text-orange-400" />
        </div>
      <% end %>
      
      <h1 class="text-center text-lg text-gray-800 dark:text-gray-200 mb-11">
        <%= gettext(
          "%{strong} Olá, bem vindo!%{close_strong}%{break_line}Continue o cadastro de você e do seu Pet para reservar uma estadia.",
          strong: "<strong>",
          close_strong: "</strong>",
          break_line: "</br>"
        )
        |> raw() %>
      </h1>
      
      <.simple_form
        for={@form}
        phx-change="validate"
        phx-submit="submit"
        phx-target={@myself}
        class="flex flex-col w-full justify-center items-center"
      >
        <.field field={@form[:name]} label={gettext("Nome Completo")} type="text" class="w-96" />
        <.field
          field={@form[:birthday]}
          label={gettext("Data de Nascimento")}
          type="date"
          class="w-96"
        />
        <.field
          type="select"
          field={@form[:gender]}
          label={gettext("Gênero")}
          options={["", gettext("Masculino"), gettext("Feminino"), gettext("Outro")]}
        /> <.field field={@form[:job]} label={gettext("Profissão")} type="text" class="w-96" />
        <:actions>
          <.button color="warning" label="Continuar" variant="shadow" class="mt-24 w-64 mx-auto" />
        </:actions>
      </.simple_form>
    </div>
    """
  end

  def mount(socket) do
    changeset = build_changeset()

    {:ok, assign_form(socket, changeset) |> assign(loading: false)}
  end

  def update(%{inn_id: inn_id, user_email: user_email}, socket) do
    user = CheckinController.get_table_cache(:user, user_email)

    changeset =
      user
      |> build_changeset()

    {:ok, assign_form(socket, changeset) |> assign(user_email: user_email, inn_id: inn_id)}
  end

  def update(_, socket) do
    {:ok, socket}
  end

  def handle_event("validate", %{"object" => object_params}, socket) do
    changeset =
      object_params
      |> build_changeset()
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("submit", %{"object" => object_params}, socket) do
    changeset = build_changeset(object_params)

    case validate_changeset(changeset) do
      {:ok, object} ->
        submit_step(socket, changeset, object)

      {:error, changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, changeset) do
    assign(socket, form: to_form(changeset, as: :object))
  end

  defp build_changeset(params \\ %{}) do
    data = %{}

    types = %{name: :string, birthday: :string, gender: :string, job: :string}

    {data, types}
    |> Ecto.Changeset.cast(params, Map.keys(types))
    |> Ecto.Changeset.validate_required(:name, message: "É necessário inserir um nome")
    |> Ecto.Changeset.validate_required(:birthday,
      message: "É necessário inserir uma data de nascimento"
    )
    |> Ecto.Changeset.validate_required(:gender, message: "É necessário selecionar um gênero")
    |> Ecto.Changeset.validate_required(:job, message: "É necessário inserir uma profissão")
  end

  defp validate_changeset(changeset) do
    Ecto.Changeset.apply_action(changeset, :validate)
  end

  defp submit_step(socket, changeset, params) do
    user_registration =
      Map.merge(
        CheckinController.get_table_cache(:user, socket.assigns.user_email),
        params
      )

    CheckinController.update_user(user_registration)

    send_update(WizardStructureComponent, %{
      id: :wizard,
      action: :can_continue,
      user_email: user_registration.email
    })

    {:noreply, assign_form(socket, changeset) |> assign(loading: true)}
  end
end
