defmodule PetInnWeb.Shared.Checkin.Steps.AddressComponent do
  @moduledoc false
  use PetInnWeb, :live_component

  alias PetInnWeb.CheckinController
  alias PetInnWeb.Shared.Wizard.WizardStructureComponent

  def render(assigns) do
    ~H"""
    <div class="w-full sm:w-[500px] flex flex-col mx-auto">
      <.simple_form
        for={@form}
        phx-change="change_form"
        phx-submit="submit"
        phx-target={@myself}
        class="flex flex-col w-full justify-center items-center"
      >
        <.field field={@form[:name]} label={gettext("Nome Completo")} type="text" class="w-96" />
        <:actions>
          <.button color="warning" label="Continuar" variant="shadow" class="mt-24 w-64 mx-auto" />
        </:actions>
      </.simple_form>
      <%!-- <div class="w-full flex flex-col items-center">
        <label class="input input-bordered flex items-center gap-2 mb-4 w-full sm:w-3/4">
          CEP
          <input type="text" class="grow" placeholder="Insira o CEP para facilitar o preenchimento" />
        </label>
        <button class="btn mb-4">Buscar</button>
        <button class="btn mb-9">Informar manualmente</button>
      </div>

      <label class="input input-bordered flex items-center gap-2 w-full pr-0 mr-2 mb-2">
        <select class="select select-bordered w-full h-[calc(3rem-2px)] min-h-[calc(3rem-2px)] text-gray-500 text-base">
          <option disabled selected>País</option>

          <option>Cachorro</option>

          <option>Gato</option>

          <option>Avés</option>

          <option>Répteis</option>

          <option>Roedores</option>
        </select>
      </label>

      <label class="input input-bordered flex items-center gap-2 w-full pr-0 mr-2 mb-2">
        <select class="select select-bordered w-full h-[calc(3rem-2px)] min-h-[calc(3rem-2px)] text-gray-500 text-base">
          <option disabled selected>Estado</option>

          <option>Cachorro</option>

          <option>Gato</option>

          <option>Avés</option>

          <option>Répteis</option>

          <option>Roedores</option>
        </select>
      </label>

      <div class="flex w-full mb-2 justify-between flex-wrap sm:flex-nowrap">
        <label class="input input-bordered flex items-center gap-2 w-full mb-2 sm:mb-0 sm:w-[calc(50%-20px)]">
          Cidade <input type="text" class="grow" />
        </label>

        <label class="input input-bordered flex items-center gap-2 w-full sm:w-[calc(50%-20px)]">
          Bairro <input type="text" class="grow" />
        </label>
      </div>

      <label class="input input-bordered flex items-center gap-2 w-full mb-2">
        Logradouro <input type="text" class="grow" />
      </label>

      <div class="flex w-full mb-2 justify-between flex-wrap sm:flex-nowrap">
        <label class="input input-bordered flex items-center gap-2 w-full mb-2 sm:mb-0 sm:w-[calc(50%-20px)]">
          Número <input type="text" class="grow" />
        </label>

        <label class="input input-bordered flex items-center gap-2 w-full sm:w-[calc(50%-20px)]">
          Complemento <input type="text" class="grow" />
        </label>
      </div> --%>
    </div>
    """
  end

  def mount(socket) do
    changeset = build_changeset()

    {:ok, socket |> assign_form(changeset) |> assign(loading: false)}
  end

  def update(_, socket) do
    {:ok, socket}
  end

  def handle_event("change_form", %{"object" => object_params}, socket) do
    changeset =
      build_changeset(object_params)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("submit", %{"object" => object_params}, socket) do
    changeset = object_params |> build_changeset() |> Map.put(:action, :validate)

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
    |> Ecto.Changeset.validate_required(:phone, message: "É necessário inserir um telefone")
  end

  defp validate_changeset(changeset) do
    Ecto.Changeset.apply_action(changeset, :validate)
  end

  defp submit_step(socket, changeset, params) do
    user_address =
      Map.put(
        CheckinController.get_table_cache(:user, socket.assigns.user_email),
        :address,
        params
      )

    CheckinController.update_user(user_address)

    send_update(WizardStructureComponent, %{
      id: :wizard,
      action: :can_continue,
      user_email: user_address.email
    })

    {:noreply, socket |> assign_form(changeset) |> assign(loading: true)}
  end
end
