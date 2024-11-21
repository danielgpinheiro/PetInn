defmodule PetInnWeb.Shared.Checkin.Steps.PetComponent do
  @moduledoc false
  use PetInnWeb, :live_component
  use Ecto.Schema

  alias PetInn.Pet.FoodHourForm
  alias PetInn.Pet.MedicineForm
  alias PetInn.Pet.PetForm
  alias PetInnWeb.CheckinController
  alias PetInnWeb.Shared.Wizard.WizardStructureComponent

  def render(assigns) do
    ~H"""
    <div class="w-[650px] mx-auto flex justify-center flex-col" phx-hook="TriggerButton" id="pet-step">
      <h1 class="text-center text-lg text-gray-800 dark:text-gray-200 mb-11">
        <%= gettext(
          "Insira os dados do seu Pet, para entendermos quais as necessidades do seu Pet na Estadia."
        ) %>
      </h1>

      <ul class="mx-auto mb-12">
        <.simple_form for={@form} phx-change="change_form" phx-submit="submit" phx-target={@myself}>
          <.inputs_for :let={pet} field={@form[:pets]}>
            <.field type="hidden" field={pet[:photo]} />
            <.field type="hidden" field={pet[:vaccination_card]} />

            <.card class="w-full p-4">
              <.card_content class="flex flex-col items-center w-full relative">
                <div class="card-actions absolute top-2 right-2">
                  <a
                    class="btn btn-square btn-sm cursor-pointer"
                    phx-click="remove_pet"
                    phx-target={@myself}
                    phx-value-index={pet.index}
                    data-tippy-content={gettext("Remover")}
                    data-tippy-placement="bottom"
                  >
                    <.icon name="hero-x-mark" class="w-6 h-6" />
                  </a>
                </div>

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
                            phx-click="remove_saved_element"
                            phx-target={@myself}
                            phx-value-index={pet.index}
                            phx-value-element={:photo}
                          >
                            <.icon name="hero-x-mark" class="w-5 h-5 dark:text-white" />
                          </a>
                        </div>
                      </div>
                    <% end %>

                    <div
                      class="w-32 h-32 p-[4px] rounded-full justify-center items-center text-gray-500 border-gray-300 flex-col mb-4 text-center relative flex border-dashed"
                      style={"border-width: #{if length(@uploads[String.to_atom("photo_#{pet.index}")].entries) == 0, do: "1px", else: "0px"}"}
                      phx-drop-target={@uploads[String.to_atom("photo_#{pet.index}")].ref}
                    >
                      <.live_file_input
                        upload={@uploads[String.to_atom("photo_#{pet.index}")]}
                        class="w-full h-full opacity-0 absolute top-0 left-0 cursor-pointer"
                      />

                      <span class="pointer-events-none dark:text-gray-200">
                        <.icon name="hero-camera" class="w-10 h-10" />
                        <br /> <%= gettext("Foto do Pet") %>
                      </span>

                      <div
                        :for={entry <- @uploads[String.to_atom("photo_#{pet.index}")].entries}
                        class="flex items-center justify-center absolute top-0 left-0 z-10 w-full h-full p-[4px]"
                      >
                        <.live_img_preview
                          entry={entry}
                          class="w-full h-full rounded-full shadow object-cover"
                        />

                        <div
                          class="radial-progress"
                          role="progressbar"
                          aria-valuenow="0"
                          aria-valuemin="0"
                          aria-valuemax="100"
                          style={"--progress:" <> Integer.to_string(entry.progress) <> "%"}
                        >
                        </div>

                        <a
                          class="btn rounded-full btn-sm absolute top-[-15px] right-[-15px] shadow bg-white dark:bg-gray-700 flex justify-center items-center w-6 h-6 cursor-pointer"
                          phx-click="cancel"
                          phx-target={@myself}
                          phx-value-ref={entry.ref}
                          phx-value-name={"photo_#{pet.index}"}
                        >
                          <.icon name="hero-x-mark" class="w-5 h-5 dark:text-white" />
                        </a>

                        <div class="absolute bottom-[-36px] left-0 text-center w-full flex justify-center whitespace-nowrap">
                          <.error :for={
                            err <-
                              upload_errors(@uploads[String.to_atom("photo_#{pet.index}")], entry)
                          }>
                            <%= upload_error_to_string(err) %>
                          </.error>
                        </div>
                      </div>
                    </div>

                    <.error :for={
                      err <- upload_errors(@uploads[String.to_atom("photo_#{pet.index}")])
                    }>
                      <%= upload_error_to_string(err) %>
                    </.error>
                  </div>

                  <div class="w-full flex justify-between">
                    <.field
                      field={pet[:name]}
                      label={gettext("Nome do Pet")}
                      type="text"
                      class="w-48 mr-2"
                    />

                    <.field
                      type="select"
                      field={pet[:specie]}
                      label={gettext("Espécie")}
                      options={List.insert_at(@species_pet_allowed, 0, "")}
                      class="w-48 mr-2"
                    />

                    <.field field={pet[:race]} label={gettext("Raça")} type="text" class="w-48 mr-2" />
                  </div>

                  <hr />

                  <div class="w-full flex items-center flex-wrap mt-2">
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
                        class="w-40"
                      />

                      <a
                        class="p-2 flex justify-center items-center cursor-pointer ml-[-27px]"
                        phx-click="remove_element"
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
                      phx-click="add_element"
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
                            phx-click="remove_saved_element"
                            phx-target={@myself}
                            phx-value-index={pet.index}
                            phx-value-element={:vaccination_card}
                          >
                            <.icon name="hero-x-mark" class="w-5 h-5 dark:text-white" />
                          </a>
                        </div>
                      </div>
                    <% end %>

                    <div
                      class="w-32 h-32 p-[4px] rounded-full justify-center items-center text-gray-500 border-gray-300 flex-col mb-4 text-center relative flex border-dashed"
                      style={"border-width: #{if length(@uploads[String.to_atom("vaccination_card_#{pet.index}")].entries) == 0, do: "1px", else: "0px"}"}
                      phx-drop-target={@uploads[String.to_atom("vaccination_card_#{pet.index}")].ref}
                    >
                      <.live_file_input
                        upload={@uploads[String.to_atom("vaccination_card_#{pet.index}")]}
                        class="w-full h-full opacity-0 absolute top-0 left-0 cursor-pointer"
                      />

                      <span class="pointer-events-none dark:text-gray-200">
                        <.icon name="hero-camera" class="w-10 h-10" />
                        <br /> <%= gettext("Cartão de vacina") %>
                      </span>

                      <div
                        :for={
                          entry <- @uploads[String.to_atom("vaccination_card_#{pet.index}")].entries
                        }
                        class="flex items-center justify-center absolute top-0 left-0 z-10 w-full h-full p-[4px]"
                      >
                        <.live_img_preview
                          entry={entry}
                          class="w-full h-full rounded-full shadow object-cover"
                        />

                        <div
                          class="radial-progress"
                          role="progressbar"
                          aria-valuenow="0"
                          aria-valuemin="0"
                          aria-valuemax="100"
                          style={"--progress:" <> Integer.to_string(entry.progress) <> "%"}
                        >
                        </div>

                        <a
                          class="btn rounded-full btn-sm absolute top-[-15px] right-[-15px] shadow bg-white dark:bg-gray-700 flex justify-center items-center w-6 h-6 cursor-pointer"
                          phx-click="cancel"
                          phx-target={@myself}
                          phx-value-ref={entry.ref}
                          phx-value-name={"vaccination_card_#{pet.index}"}
                        >
                          <.icon name="hero-x-mark" class="w-5 h-5 dark:text-white" />
                        </a>

                        <div class="absolute bottom-[-36px] left-0 text-center w-full flex justify-center whitespace-nowrap">
                          <.error :for={
                            err <-
                              upload_errors(
                                @uploads[String.to_atom("vaccination_card_#{pet.index}")],
                                entry
                              )
                          }>
                            <%= upload_error_to_string(err) %>
                          </.error>
                        </div>
                      </div>
                    </div>

                    <.error :for={
                      err <- upload_errors(@uploads[String.to_atom("vaccination_card_#{pet.index}")])
                    }>
                      <%= upload_error_to_string(err) %>
                    </.error>
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
                      />

                      <a
                        class="p-2 flex justify-center items-center cursor-pointer"
                        phx-click="remove_element"
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
                      phx-click="add_element"
                      phx-value-pet_index={pet.index}
                      phx-value-element={:medicines}
                      phx-target={@myself}
                    >
                      <.icon name="hero-plus" class="w-6 h-6 mr-2" /> <%= gettext(
                        "Adicionar novo remédio"
                      ) %>
                    </a>
                  </div>

                  <.field field={pet[:notes]} type="text" label={gettext("Observações sobre o Pet")} />
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

  @max_entries 1
  @max_file_size 5_000_000

  embedded_schema do
    field :empty_field, :string
    has_many :pets, PetForm
  end

  def mount(socket) do
    changeset = build_changeset()

    {:ok,
     socket
     |> assign_form(changeset)
     |> allow_upload(:photo_0, accept: ~w(.png .jpg .jpeg), max_entries: @max_entries, max_file_size: @max_file_size)
     |> allow_upload(:vaccination_card_0,
       accept: ~w(.png .jpg .jpeg),
       max_entries: @max_entries,
       max_file_size: @max_file_size
     )
     |> assign(loading: false)}
  end

  def update(%{inn: inn, user_email: user_email}, socket) do
    # user = CheckinController.get_table_cache(:user, user_email)

    # pets = handle_user_pets(CheckinController.get_pets(user.id))
    pets = handle_user_pets(CheckinController.get_pets("813fce44-a335-42e2-8c41-aa8d2207c87b"))

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

        IO.inspect(changeset)

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

  def handle_event("cancel", %{"ref" => ref, "name" => name}, socket) do
    {:noreply, cancel_upload(socket, String.to_atom(name), ref)}
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
      EctoNestedChangeset.append_at(socket.assigns.form.source, :pets, %{})

    index = length(Map.get(changeset.changes, :pets))

    {:noreply,
     socket
     |> assign_form(changeset)
     |> allow_upload(String.to_atom("photo_#{index - 1}"),
       accept: ~w(.png .jpg .jpeg),
       max_entries: @max_entries,
       max_file_size: @max_file_size
     )
     |> allow_upload(String.to_atom("vaccination_card_#{index - 1}"),
       accept: ~w(.png .jpg .jpeg),
       max_entries: @max_entries,
       max_file_size: @max_file_size
     )}
  end

  def handle_event("remove_pet", %{"index" => index}, socket) do
    index = String.to_integer(index)

    photo = socket.assigns.uploads[String.to_atom("photo_#{index}")]
    vaccination_card = socket.assigns.uploads[String.to_atom("vaccination_card_#{index}")]

    changeset =
      EctoNestedChangeset.delete_at(
        socket.assigns.form.source,
        [:pets, index],
        mode: {:flag, :delete}
      )

    cond do
      length(photo.entries) === 0 and length(vaccination_card.entries) === 0 ->
        {:noreply, assign_form(socket, changeset)}

      length(photo.entries) > 0 and length(vaccination_card.entries) > 0 ->
        {:noreply,
         socket
         |> cancel_upload(String.to_atom("photo_#{index}"), Enum.at(photo.entries, 0).ref)
         |> cancel_upload(String.to_atom("vaccination_card_#{index}"), Enum.at(vaccination_card.entries, 0).ref)
         |> assign_form(changeset)}

      length(photo.entries) > 0 ->
        {:noreply,
         socket
         |> cancel_upload(String.to_atom("photo_#{index}"), Enum.at(photo.entries, 0).ref)
         |> assign_form(changeset)}

      length(vaccination_card.entries) > 0 ->
        {:noreply,
         socket
         |> cancel_upload(String.to_atom("vaccination_card_#{index}"), Enum.at(vaccination_card.entries, 0).ref)
         |> assign_form(changeset)}
    end
  end

  def handle_event("add_element", %{"pet_index" => pet_index, "element" => element}, socket) do
    element = String.to_atom(element)

    changeset =
      EctoNestedChangeset.append_at(
        socket.assigns.form.source,
        [:pets, String.to_integer(pet_index), element],
        %{}
      )

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("remove_element", %{"index" => index, "pet_index" => pet_index, "element" => element}, socket) do
    element = String.to_atom(element)
    index = String.to_integer(index)
    pet_index = String.to_integer(pet_index)

    changeset =
      EctoNestedChangeset.delete_at(socket.assigns.form.source, [:pets, pet_index, element, index],
        mode: {:action, :delete}
      )

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("remove_saved_element", %{"index" => index, "element" => element}, socket) do
    element = String.to_atom(element)
    pet = socket.assigns.form.source.params["pets"] |> Enum.at(String.to_integer(index)) |> Map.replace(element, nil)
    pets = List.replace_at(socket.assigns.form.source.params["pets"], String.to_integer(index), pet)

    map_pets =
      Enum.map(pets, fn pet ->
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

    changeset = Map.new() |> Map.put("pets", map_pets) |> build_changeset()

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
            %PetForm{
              id: Ecto.UUID.generate(),
              food_hours: [%FoodHourForm{id: Ecto.UUID.generate()}],
              medicines: [%MedicineForm{id: Ecto.UUID.generate()}]
            }
          ]
        }
      else
        %__MODULE__{
          pets: []
        }
      end

    changeset
    |> Ecto.Changeset.cast(params, [:empty_field])
    |> Ecto.Changeset.cast_assoc(:pets,
      required: false,
      with: &PetForm.changeset/2
    )
  end

  defp validate_changeset(changeset) do
    Ecto.Changeset.apply_action(changeset, :validate)
  end

  defp handle_file_upload(socket, name) do
    [file_path] =
      consume_uploaded_entries(socket, name, fn %{path: path}, entry ->
        path_with_extension = path <> String.replace(entry.client_type, "image/", ".")
        dest = Path.join(Application.app_dir(:pet_inn, "priv/static/uploads"), Path.basename(path_with_extension))
        {:ok, ~p"/uploads/#{Path.basename(dest)}"}
      end)

    file_path
  end

  defp submit_step(socket, changeset, params) do
    pets =
      params.pets
      |> Enum.with_index()
      |> Enum.map(fn {pet, index} ->
        uploads = socket.assigns.uploads
        photo_assign = String.to_atom("photo_#{index}")
        vaccination_card_assign = String.to_atom("vaccination_card_#{index}")
        photo_entries = uploads[photo_assign].entries
        vaccination_card_entries = uploads[vaccination_card_assign].entries

        photo_path =
          if length(photo_entries) > 0 and pet.photo === nil,
            do: handle_file_upload(socket, photo_assign),
            else: pet.photo

        vaccination_card_path =
          if length(vaccination_card_entries) > 0 and pet.vaccination_card === nil,
            do: handle_file_upload(socket, vaccination_card_assign),
            else: pet.vaccination_card

        %{pet | photo: photo_path, vaccination_card: vaccination_card_path}
      end)

    user_data_with_pets =
      Map.put(
        CheckinController.get_table_cache(:user, socket.assigns.user_email),
        :pets,
        pets
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

  defp upload_error_to_string(:too_many_files), do: gettext("Permitido somente 1 arquivo.")
  defp upload_error_to_string(:too_large), do: gettext("Arquivo muito grande.")
  defp upload_error_to_string(:not_accepted), do: gettext("Tipo de arquivo não aceito.")
  defp upload_error_to_string(:external_client_failure), do: gettext("Algo deu errado.")
end
