defmodule PetInnWeb.Shared.Checkin.Steps.AddressComponent do
  @moduledoc false
  use PetInnWeb, :live_component

  alias PetInnWeb.Shared.Wizard.WizardStructureComponent
  alias PetInnWeb.UserController
  alias PetInnWeb.Utils.EtsUtils

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
          options={@countries}
          prompt={gettext("Selecione uma opção")}
          class="w-full sm:w-[450px]"
        />
        <.field
          field={@form[:state]}
          label={gettext("Estado")}
          type="select"
          options={@states}
          prompt={gettext("Selecione uma opção")}
          class="w-full sm:w-[450px]"
        />
        <div class="flex w-full justify-between">
          <.field
            field={@form[:city]}
            label={gettext("Cidade")}
            type="select"
            options={@cities}
            prompt={gettext("Selecione uma opção")}
            class="w-40 sm:w-52"
          />
          <.field
            field={@form[:neighborhood]}
            label={gettext("Bairro")}
            type="text"
            class="w-40 sm:w-52"
          />
        </div>

        <.field
          field={@form[:street]}
          label={gettext("Logradouro")}
          type="text"
          class="w-full sm:w-[450px]"
        />
        <div class="flex w-full justify-between">
          <.field field={@form[:number]} label={gettext("Número")} type="text" class="w-28 sm:w-36" />
          <.field
            field={@form[:complement]}
            label={gettext("Complemento")}
            type="text"
            class="w-28 sm:w-36"
          /> <.field field={@form[:code]} label={gettext("CEP")} type="text" class="w-28 sm:w-36" />
        </div>

        <:actions>
          <.button color="warning" label="Continuar" variant="shadow" class="mt-24 w-64 mx-auto" />
        </:actions>
      </.simple_form>
    </div>
    """
  end

  def mount(socket) do
    changeset = build_changeset()

    countries =
      Place.get_countries()
      |> Enum.map(fn country ->
        {Map.get(country.translations, String.replace(Gettext.get_locale(), "_", "-"), country.name), country.iso2}
      end)
      |> Enum.sort()

    {:ok,
     socket
     |> assign_form(changeset)
     |> assign(loading: false)
     |> assign(countries: countries)
     |> assign(states: [])
     |> assign(cities: [])}
  end

  def update(%{inn: inn, user: _user, booking: _booking, user_email: user_email}, socket) do
    user = EtsUtils.get_table_cache(:user, user_email)

    address =
      case Map.get(user, :id) do
        nil -> {:not_found}
        _ -> UserController.get_user_address(user.id)
      end

    case address do
      {:not_found} ->
        {:ok, assign(socket, user_email: user_email, inn: inn)}

      _ ->
        changeset =
          build_changeset(%{
            city: address.city,
            code: address.code,
            complement: address.complement,
            country: address.country,
            neighborhood: address.neighborhood,
            number: address.number,
            state: address.state,
            street: address.street
          })

        states = get_states(address.country)
        cities = get_cities(address.country, address.state)

        {:ok,
         socket |> assign_form(changeset) |> assign(user_email: user_email, inn: inn, states: states, cities: cities)}
    end
  end

  def update(_, socket) do
    {:ok, socket}
  end

  def handle_event("change_form", %{"object" => object_params}, socket) do
    previous_selected_country = Map.get(socket.assigns.form.params, "country")
    selected_country = Map.get(object_params, "country")

    previous_selected_state = Map.get(socket.assigns.form.params, "state")
    selected_state = Map.get(object_params, "state")

    states =
      if previous_selected_country !== selected_country and selected_country !== "" do
        Map.replace(object_params, "state", "")
        Map.replace(object_params, "city", "")

        get_states(selected_country)
      else
        socket.assigns.states
      end

    cities =
      if previous_selected_state !== selected_state and selected_state !== "" do
        Map.replace(object_params, "city", "")

        get_cities(selected_country, selected_state)
      else
        socket.assigns.cities
      end

    changeset =
      build_changeset(object_params)

    {:noreply, socket |> assign_form(changeset) |> assign(states: states) |> assign(cities: cities)}
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

  defp get_states(selected_country) do
    [country_code: selected_country]
    |> Place.get_states()
    |> Enum.map(fn state ->
      {state.name, state.state_code}
    end)
    |> Enum.sort()
  end

  defp get_cities(selected_country, selected_state) do
    [country_code: selected_country, state_code: selected_state]
    |> Place.get_cities()
    |> Enum.map(fn city ->
      city.name
    end)
    |> Enum.sort()
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
    |> Ecto.Changeset.validate_required(:code, message: "É necessário inserir um CEP")
  end

  defp validate_changeset(changeset) do
    Ecto.Changeset.apply_action(changeset, :validate)
  end

  defp submit_step(socket, changeset, params) do
    user_address =
      Map.put(
        EtsUtils.get_table_cache(:user, socket.assigns.user_email),
        :address,
        params
      )

    UserController.update_user(user_address)

    send_update(WizardStructureComponent, %{
      id: :wizard,
      action: :can_continue
    })

    {:noreply, socket |> assign_form(changeset) |> assign(loading: true)}
  end
end
