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
        <.field
          field={@form[:country]}
          label={gettext("País")}
          type="select"
          options={[{"Option 1", "1"}, {"Option 2", "2"}, {"Option 3", "3"}]}
          prompt={gettext("Selecione uma opção")}
          class="w-[450px]"
        />
        <.field
          field={@form[:state]}
          label={gettext("Estado")}
          type="select"
          options={[{"Option 1", "1"}, {"Option 2", "2"}, {"Option 3", "3"}]}
          prompt={gettext("Selecione uma opção")}
          class="w-[450px]"
        />

        <div class="flex w-full justify-between">
          <.field
            field={@form[:city]}
            label={gettext("Cidade")}
            type="select"
            options={[{"Option 1", "1"}, {"Option 2", "2"}, {"Option 3", "3"}]}
            prompt={gettext("Selecione uma opção")}
            class="w-52"
          />

          <.field field={@form[:neighborhood]} label={gettext("Bairro")} type="text" class="w-52" />
        </div>

        <.field field={@form[:street]} label={gettext("Logradouro")} type="text" class="w-[450px]" />

        <div class="flex w-full justify-between">
          <.field field={@form[:number]} label={gettext("Número")} type="text" class="w-36" />
          <.field field={@form[:complement]} label={gettext("Complemento")} type="text" class="w-36" />
          <.field field={@form[:code]} label={gettext("CEP")} type="text" class="w-36" />
        </div>

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

    types = %{
      country: :string,
      state: :string,
      city: :string,
      neighborhood: :string,
      street: :string,
      number: :string,
      complement: :string,
      code: :string
    }

    {data, types}
    |> Ecto.Changeset.cast(params, Map.keys(types))
    |> Ecto.Changeset.validate_required(:country, message: "É necessário selecionar um País")
    |> Ecto.Changeset.validate_required(:state, message: "É necessário selecionar um Estado")
    |> Ecto.Changeset.validate_required(:city, message: "É necessário selecionar uma Cidade")
    |> Ecto.Changeset.validate_required(:street, message: "É necessário inserir uma Rua")
    |> Ecto.Changeset.validate_required(:number, message: "É necessário inserir um Número")
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

    IO.inspect(user_address)

    # CheckinController.update_user(user_address)

    # send_update(WizardStructureComponent, %{
    #   id: :wizard,
    #   action: :can_continue,
    #   user_email: user_address.email
    # })

    {:noreply, socket |> assign_form(changeset) |> assign(loading: true)}
  end
end
