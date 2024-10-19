defmodule PetInnWeb.Shared.Checkin.Steps.VerifyComponent do
  use PetInnWeb, :live_component

  alias PetInnWeb.Shared.Wizard.WizardStructureComponent
  alias PetInnWeb.CheckinController

  def render(assigns) do
    ~H"""
    <div class="w-full sm:w-[550px] mx-auto flex flex-col justify-center items-center relative">
      <%= if @loading do %>
        <div class="w-full h-full absolute z-50 flex justify-center items-center bg-white bg-opacity-10 rounded-lg">
          <.spinner show={true} size="lg" class="pointer-events-none text-orange-400" />
        </div>
      <% end %>
      
      <h1 class="text-center text-lg text-gray-800 dark:text-gray-200 mb-11">
        <%= gettext(
          "Em pouco tempo, o cadastro de você e do seu Pet será feito. %{break_line} Após isso, você poderá reutilizar seu registro em outros lugares com o ecosistema Pet Inns.",
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
        <.field type="email" field={@form[:email]} class="w-96" />
        <.live_component
          module={LivePhone}
          id="phone"
          form={@form}
          field={:phone}
          apply_format?={true}
          preferred={["BR", "US", "ES"]}
          placeholder={gettext("Número de Telefone")}
        />
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

    types = %{email: :string, phone: :string}

    {data, types}
    |> Ecto.Changeset.cast(params, Map.keys(types))
    |> Ecto.Changeset.validate_required(:email, message: "É necessário inserir um e-mail")
    |> Ecto.Changeset.validate_format(:email, ~r/@/,
      message: "É necessário inserir um e-mail válido"
    )
    |> Ecto.Changeset.validate_required(:phone, message: "É necessário inserir um telefone")
  end

  defp validate_changeset(changeset) do
    Ecto.Changeset.apply_action(changeset, :validate)
  end

  defp submit_step(socket, changeset, params) do
    if LivePhone.Util.valid?(params.phone) do
      CheckinController.create_or_load_user(params)

      send_update(WizardStructureComponent, %{
        id: :wizard,
        action: :can_continue,
        user_email: params.email
      })

      {:noreply, assign_form(socket, changeset) |> assign(loading: true)}
    else
      {:noreply, assign_form(socket, changeset)}
    end
  end
end
