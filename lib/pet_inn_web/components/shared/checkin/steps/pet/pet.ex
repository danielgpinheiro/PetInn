defmodule PetInnWeb.Shared.Checkin.Steps.Pet.PetComponent do
  @moduledoc false
  use PetInnWeb, :live_component
  use Ecto.Schema

  alias PetInnWeb.CheckinController
  alias PetInnWeb.Shared.Checkin.Steps.Pet.FoodHourFormSchema
  alias PetInnWeb.Shared.Checkin.Steps.Pet.MedicineFormSchema
  alias PetInnWeb.Shared.Checkin.Steps.Pet.PetFormSchema
  alias PetInnWeb.Shared.Wizard.WizardStructureComponent

  def render(assigns) do
    ~H"""
    <div
      class="w-full sm:w-[650px] mx-auto flex justify-center flex-col"
      phx-hook="TriggerButton"
      id="pet-step"
    >
      <h1 class="text-center text-lg text-gray-800 dark:text-gray-200 mb-11">
        <%= gettext(
          "Insira os dados do seu Pet, para entendermos quais as necessidades do seu Pet na Estadia."
        ) %>
      </h1>

      <ul class="w-full mx-auto mb-12" id="form" phx-hook="InputFileToBase64">
        <.simple_form for={@form} phx-change="change_form" phx-submit="submit" phx-target={@myself}>
          <.inputs_for :let={pet} field={@form[:pets]}>
            <.field type="hidden" field={pet[:photo]} />
            <.field type="hidden" field={pet[:vaccination_card]} />

            <.card class="w-full p-4">
              <.card_content class="flex flex-col items-center w-full relative">
                <%= if length(@form[:pets].value) !== 1 do %>
                  <div class="card-actions absolute top-2 right-2">
                    <a
                      class="btn btn-square btn-sm cursor-pointer"
                      phx-click="remove_pet"
                      phx-target={@myself}
                      phx-value-index={pet.index}
                      data-tippy-content={gettext("Remover Pet")}
                      data-tippy-placement="bottom"
                    >
                      <.icon name="hero-x-mark" class="w-6 h-6" />
                    </a>
                  </div>
                <% end %>

                <div class="w-full block space-y-8">
                  <div class="flex w-full justify-center items-center relative mb-10">
                    <%= if pet[:photo].value != nil and pet[:photo].value !== "" do %>
                      <div class="w-full h-[132px] absolute top-0 left-0 z-10 flex justify-center items-center">
                        <div class="w-[132px] h-full rounded-full justify-center items-center text-gray-500 border-gray-300 flex-col text-center flex relative">
                          <img
                            src={pet[:photo].value}
                            class="w-full h-full rounded-full shadow object-cover"
                          />
                          <a
                            class="btn rounded-full btn-sm absolute top-[-15px] right-[-15px] shadow bg-white dark:bg-gray-700 flex justify-center items-center w-6 h-6 cursor-pointer"
                            phx-click="change_form_element"
                            phx-target={@myself}
                            phx-value-index={pet.index}
                            phx-value-element={:photo}
                          >
                            <.icon name="hero-x-mark" class="w-5 h-5 dark:text-white" />
                          </a>
                        </div>
                      </div>
                    <% end %>

                    <label
                      class="w-32 h-32 p-[4px] rounded-full justify-center items-center text-gray-500 border-gray-300 flex-col mb-4 text-center relative flex border-dashed"
                      style={"border-width: #{if pet[:photo].value != nil and pet[:photo].value !== "", do: "0px", else: "1px"}"}
                    >
                      <input
                        type="file"
                        class="file-input hidden"
                        data-element="photo"
                        data-index={pet.index}
                        accept="image/*"
                      />

                      <span class="pointer-events-none dark:text-gray-200">
                        <.icon name="hero-camera" class="w-10 h-10" />
                        <br /> <%= gettext("Foto do Pet") %>
                      </span>
                    </label>
                  </div>

                  <div class="w-full flex flex-col sm:flex-row justify-between">
                    <.field
                      field={pet[:name]}
                      label={gettext("Nome do Pet")}
                      type="text"
                      class="w-full sm:w-48 sm:mr-2 mb-2 sm:mb-0"
                    />

                    <.field
                      type="select"
                      field={pet[:specie]}
                      label={gettext("Espécie")}
                      options={@species_pet_allowed}
                      class="w-full sm:w-48 sm:mr-2 mb-2 sm:mb-0"
                      prompt={gettext("Selecione uma raça")}
                    />

                    <.field
                      field={pet[:race]}
                      label={gettext("Raça")}
                      type="text"
                      class="w-full sm:w-48 sm:mr-2 mb-2 sm:mb-0"
                    />
                  </div>

                  <hr />

                  <div class="w-full flex sm:items-center flex-wrap mt-2">
                    <.inputs_for :let={food_hour} field={pet[:food_hours]}>
                      <.field
                        type="time"
                        label={
                          gettext(
                            "%{index}º Horário da Alimentação",
                            index: food_hour.index + 1
                          )
                        }
                        field={food_hour[:hour]}
                        class="w-full sm:w-40"
                      />

                      <a
                        class="p-2 flex justify-center items-center cursor-pointer sm:ml-[-27px]"
                        phx-click="remove_nested_element"
                        phx-target={@myself}
                        phx-value-index={food_hour.index}
                        phx-value-pet_index={pet.index}
                        phx-value-element={:food_hours}
                        data-tippy-content={gettext("Remover")}
                        data-tippy-placement="bottom"
                      >
                        <.icon name="hero-minus-circle" />
                      </a>
                    </.inputs_for>
                  </div>

                  <.field
                    type="switch"
                    label={gettext("Alimentação é comida natural?")}
                    field={pet[:is_natural_food]}
                  />

                  <div class="w-full flex justify-center">
                    <a
                      color="white"
                      variant="outline"
                      class="border-[1px] border-gray-600 dark:border-white text-gray-600 dark:text-white py-[4px] px-2 rounded text-sm cursor-pointer"
                      phx-click="add_nested_element"
                      phx-value-pet_index={pet.index}
                      phx-value-element={:food_hours}
                      phx-target={@myself}
                    >
                      <.icon name="hero-plus" class="w-6 h-6 mr-2" /> <%= gettext(
                        "Adicionar novo horário"
                      ) %>
                    </a>
                  </div>

                  <hr />

                  <div class="flex w-full justify-center items-center relative mb-10">
                    <%= if pet[:vaccination_card].value != nil and pet[:vaccination_card].value !== "" do %>
                      <div class="w-full h-[132px] absolute top-0 left-0 z-10 flex justify-center items-center">
                        <div class="w-[132px] h-full rounded-full justify-center items-center text-gray-500 border-gray-300 flex-col text-center flex relative">
                          <img
                            src={pet[:vaccination_card].value}
                            class="w-full h-full rounded-full shadow object-cover"
                          />
                          <a
                            class="btn rounded-full btn-sm absolute top-[-15px] right-[-15px] shadow bg-white dark:bg-gray-700 flex justify-center items-center w-6 h-6 cursor-pointer"
                            phx-click="change_form_element"
                            phx-target={@myself}
                            phx-value-index={pet.index}
                            phx-value-element={:vaccination_card}
                          >
                            <.icon name="hero-x-mark" class="w-5 h-5 dark:text-white" />
                          </a>
                        </div>
                      </div>
                    <% end %>

                    <label
                      class="w-32 h-32 p-[4px] rounded-full justify-center items-center text-gray-500 border-gray-300 flex-col mb-4 text-center relative flex border-dashed"
                      style={"border-width: #{if pet[:vaccination_card].value != nil and pet[:vaccination_card].value !== "", do: "0px", else: "1px"}"}
                    >
                      <input
                        type="file"
                        class="file-input hidden"
                        data-element="vaccination_card"
                        data-index={pet.index}
                        accept="image/*"
                      />

                      <span class="pointer-events-none dark:text-gray-200">
                        <.icon name="hero-camera" class="w-10 h-10" />
                        <br /> <%= gettext("Cartão de Vacina") %>
                      </span>
                    </label>
                  </div>

                  <div class="w-full flex items-center flex-wrap mt-2">
                    <.inputs_for :let={medicine} field={pet[:medicines]}>
                      <.field
                        type="text"
                        label={
                          gettext(
                            "%{index}º Remédio",
                            index: medicine.index + 1
                          )
                        }
                        field={medicine[:name]}
                        class="w-full"
                      />

                      <div class="mr-2" />

                      <.field
                        type="time"
                        label={
                          gettext(
                            "Horário do Remédio",
                            index: medicine.index + 1
                          )
                        }
                        field={medicine[:hours]}
                        class="sm:w-40"
                      />

                      <a
                        class="p-2 flex justify-center items-center cursor-pointer"
                        phx-click="remove_nested_element"
                        phx-target={@myself}
                        phx-value-index={medicine.index}
                        phx-value-pet_index={pet.index}
                        phx-value-element={:medicines}
                        data-tippy-content={gettext("Remover")}
                        data-tippy-placement="bottom"
                      >
                        <.icon name="hero-minus-circle" />
                      </a>
                    </.inputs_for>
                  </div>

                  <div class="w-full flex justify-center">
                    <a
                      color="white"
                      variant="outline"
                      class="border-[1px] border-gray-600 dark:border-white text-gray-600 dark:text-white py-[4px] px-2 rounded text-sm cursor-pointer"
                      phx-click="add_nested_element"
                      phx-value-pet_index={pet.index}
                      phx-value-element={:medicines}
                      phx-target={@myself}
                    >
                      <.icon name="hero-plus" class="w-6 h-6 mr-2" /> <%= gettext(
                        "Adicionar novo remédio"
                      ) %>
                    </a>
                  </div>

                  <.field
                    field={pet[:notes]}
                    type="textarea"
                    label={gettext("Observações sobre o Pet")}
                  />
                </div>
              </.card_content>
            </.card>
          </.inputs_for>
          <:actions>
            <.button
              color="warning"
              variant="shadow"
              class="opacity-0 w-[1px] h-[1px] absolute top-0 left-0 pointer-events-none"
              id="pet-submit-button"
            />
          </:actions>
        </.simple_form>
      </ul>

      <.button
        color="white"
        variant="outline"
        class="w-64 mx-auto"
        phx-click="add_pet"
        phx-target={@myself}
      >
        <.icon name="hero-plus" class="w-6 h-6 mr-2" /> <%= gettext("Adicionar outro Pet") %>
      </.button>

      <.button
        color="warning"
        label={gettext("Continuar")}
        variant="shadow"
        class="mt-12 w-64 mx-auto"
        phx-click="trigger_button"
        phx-target={@myself}
        phx-value-button_id="pet-submit-button"
      />
    </div>
    """
  end

  embedded_schema do
    field :empty_field, :string
    has_many :pets, PetFormSchema
  end

  def mount(socket) do
    changeset = build_changeset()

    {:ok,
     socket
     |> assign_form(changeset)
     |> assign(loading: false)}
  end

  def update(%{inn: inn, user_email: user_email}, socket) do
    user = CheckinController.get_table_cache(:user, user_email)
    pets = handle_user_pets(CheckinController.get_pets(user.id))

    species_pet_allowed =
      inn.species_pet_allowed
      |> Enum.at(0)
      |> String.replace(~s("), "")
      |> String.replace(" ", "")
      |> String.split(",")

    case pets do
      {:not_found} ->
        {:ok, assign(socket, user_email: user_email, inn: inn, species_pet_allowed: species_pet_allowed)}

      _ ->
        changeset = build_changeset(pets)

        {:ok,
         socket
         |> assign_form(changeset)
         |> assign(user_email: user_email, inn: inn, species_pet_allowed: species_pet_allowed)}
    end
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
        {:noreply,
         push_event(
           assign_form(socket, changeset),
           "scroll_to_element",
           %{element: "body", top: 0, left: 0, behavior: "smooth", fade_wizard: false}
         )}
    end
  end

  def handle_event("trigger_button", %{"button_id" => button_id}, socket) do
    {:noreply,
     push_event(
       socket,
       "trigger_button",
       %{button_id: button_id}
     )}
  end

  def handle_event("add_pet", _, socket) do
    changeset =
      EctoNestedChangeset.append_at(socket.assigns.form.source, :pets, %{
        food_hours: [%FoodHourFormSchema{id: Ecto.UUID.generate()}],
        medicines: [%MedicineFormSchema{id: Ecto.UUID.generate()}]
      })

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("remove_pet", %{"index" => index}, socket) do
    index = String.to_integer(index)

    changeset =
      EctoNestedChangeset.delete_at(
        socket.assigns.form.source,
        [:pets, index],
        mode: {:flag, :delete}
      )

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("add_nested_element", %{"pet_index" => pet_index, "element" => element}, socket) do
    element = String.to_atom(element)

    changeset =
      EctoNestedChangeset.append_at(
        socket.assigns.form.source,
        [:pets, String.to_integer(pet_index), element],
        %{}
      )

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("remove_nested_element", %{"index" => index, "pet_index" => pet_index, "element" => element}, socket) do
    element = String.to_atom(element)
    index = String.to_integer(index)
    pet_index = String.to_integer(pet_index)

    changeset =
      EctoNestedChangeset.delete_at(socket.assigns.form.source, [:pets, pet_index, element, index],
        mode: {:action, :delete}
      )

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("file_too_big", _, socket) do
    send(
      self(),
      {:update_flash, {:error, gettext("O arquivo de imagem máximo permitido é de 1MB. Tente outro arquivo.")}}
    )

    {:noreply, socket}
  end

  def handle_event("change_form_element", params, socket) do
    pets =
      cond do
        is_list(socket.assigns.form.source.params["pets"]) ->
          base64 = Map.get(params, "base64", nil)
          element = params |> Map.get("element", nil) |> String.to_atom()
          index = params |> Map.get("index", nil) |> String.to_integer()
          pet = socket.assigns.form.source.params["pets"] |> Enum.at(index) |> Map.replace(element, base64)

          socket.assigns.form.source.params["pets"]
          |> List.replace_at(index, pet)
          |> Enum.map(fn pet ->
            %{
              name: pet.name,
              is_natural_food: pet.is_natural_food,
              notes: pet.notes,
              race: pet.race,
              specie: pet.specie,
              photo: pet.photo,
              vaccination_card: pet.vaccination_card,
              food_hours: pet.food_hours,
              medicines: pet.medicines
            }
          end)

        is_map(socket.assigns.form.source.params["pets"]) ->
          base64 = Map.get(params, "base64", nil)
          element = Map.get(params, "element", nil)
          index = Map.get(params, "index", nil)
          pet = socket.assigns.form.source.params["pets"] |> Map.get(index) |> Map.replace(element, base64)
          Map.replace(socket.assigns.form.source.params["pets"], index, pet)
      end

    changeset = Map.new() |> Map.put("pets", pets) |> build_changeset()

    {:noreply, assign_form(socket, changeset)}
  end

  defp assign_form(socket, changeset) do
    assign(socket, form: to_form(changeset, as: :object))
  end

  defp build_changeset(params \\ %{}) do
    changeset =
      if length(Map.keys(params)) == 0 do
        %__MODULE__{
          pets: [
            %PetFormSchema{
              id: Ecto.UUID.generate(),
              food_hours: [%FoodHourFormSchema{id: Ecto.UUID.generate()}],
              medicines: [%MedicineFormSchema{id: Ecto.UUID.generate()}]
            }
          ]
        }
      else
        %__MODULE__{
          pets: %{}
        }
      end

    changeset
    |> Ecto.Changeset.cast(params, [:empty_field])
    |> Ecto.Changeset.cast_assoc(:pets,
      required: false,
      with: &PetFormSchema.changeset/2
    )
  end

  defp validate_changeset(changeset) do
    Ecto.Changeset.apply_action(changeset, :validate)
  end

  defp submit_step(socket, changeset, params) do
    user_data_with_pets =
      Map.put(
        CheckinController.get_table_cache(:user, socket.assigns.user_email),
        :pets,
        params
      )

    CheckinController.update_user(user_data_with_pets)

    send_update(WizardStructureComponent, %{
      id: :wizard,
      action: :can_continue,
      user_email: user_data_with_pets.email
    })

    {:noreply, socket |> assign_form(changeset) |> assign(loading: true)}
  end

  defp handle_user_pets(pets) do
    case pets do
      {:not_found} ->
        {:not_found}

      _ ->
        map_pets =
          Enum.map(pets, fn pet ->
            %{
              name: pet.name,
              is_natural_food: pet.is_natural_food,
              notes: pet.notes_about_pet,
              race: pet.race,
              specie: pet.specie,
              photo: pet.photo,
              vaccination_card: pet.vaccination_card,
              food_hours:
                if(pet.food_hours === nil,
                  do: [%{}],
                  else: Enum.map(pet.food_hours, fn hour -> %{hour: hour} end)
                ),
              medicines:
                if(length(pet.medicines),
                  do: Enum.map(pet.medicines, fn medicine -> %{name: medicine.name, hours: medicine.hours} end),
                  else: [%{}]
                )
            }
          end)

        Map.put(Map.new(), "pets", map_pets)
    end
  end
end
