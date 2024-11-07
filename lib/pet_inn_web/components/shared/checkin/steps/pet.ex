defmodule PetInnWeb.Shared.Checkin.Steps.PetComponent do
  @moduledoc false
  use PetInnWeb, :live_component
  use Ecto.Schema

  alias PetInn.Pet.FoodHours
  alias PetInn.Pet.Medicine
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
        <.card class="w-full p-4">
          <.card_content class="flex flex-col items-center w-full relative">
            <div class="card-actions absolute top-2 right-2">
              <button class="btn btn-square btn-sm">
                <.icon name="hero-x-mark" class="w-6 h-6" />
              </button>
            </div>

            <.simple_form
              for={@form}
              phx-change="change_form"
              phx-submit="submit"
              phx-target={@myself}
              class="flex flex-col w-full justify-center items-center"
            >
              <div class="flex w-full justify-center items-center relative mb-10">
                <div
                  class="w-32 h-32 p-[4px] rounded-full justify-center items-center text-gray-500 border-gray-300 flex-col mb-4 text-center relative flex border-dashed"
                  style={"border-width: #{if length(@uploads.photo.entries) == 0, do: "1px", else: "0px"}"}
                  phx-drop-target={@uploads.photo.ref}
                >
                  <.live_file_input
                    upload={@uploads.photo}
                    class="w-full h-full opacity-0 absolute top-0 left-0 cursor-pointer"
                  />

                  <span class="pointer-events-none dark:text-gray-200">
                    <.icon name="hero-camera" class="w-10 h-10" />
                    <br /> <%= gettext("Foto do Pet") %>
                  </span>

                  <div
                    :for={entry <- @uploads.photo.entries}
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
                      phx-value-name={:photo}
                    >
                      <.icon name="hero-x-mark" class="w-5 h-5 dark:text-white" />
                    </a>

                    <div class="absolute bottom-[-36px] left-0 text-center w-full flex justify-center whitespace-nowrap">
                      <.error :for={err <- upload_errors(@uploads.photo, entry)}>
                        <%= upload_error_to_string(err) %>
                      </.error>
                    </div>
                  </div>
                </div>

                <.error :for={err <- upload_errors(@uploads.photo)}>
                  <%= upload_error_to_string(err) %>
                </.error>
              </div>

              <div class="w-full flex justify-between">
                <.field
                  field={@form[:name]}
                  label={gettext("Nome do Pet")}
                  type="text"
                  class="w-48 mr-2"
                />

                <.field
                  type="select"
                  field={@form[:specie]}
                  label={gettext("Espécie")}
                  options={List.insert_at(@species_pet_allowed, 0, "")}
                  class="w-48 mr-2"
                />

                <.field field={@form[:race]} label={gettext("Raça")} type="text" class="w-48 mr-2" />
              </div>

              <hr />

              <div class="w-full flex items-center flex-wrap mt-2">
                <.inputs_for :let={item_food_hour} field={@form[:food_hours]}>
                  <.field
                    type="time"
                    label={
                      gettext(
                        "%{index}º Horário da Alimentação",
                        index: item_food_hour.index + 1
                      )
                    }
                    field={item_food_hour[:hour]}
                    class="w-40"
                  />

                  <a
                    class="p-2 flex justify-center items-center cursor-pointer ml-[-27px]"
                    phx-click="remove_food_hours"
                    phx-target={@myself}
                    phx-value-index={item_food_hour.index}
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
                field={@form[:is_natural_food]}
              />

              <div class="w-full flex justify-center">
                <a
                  color="white"
                  variant="outline"
                  class="border-[1px] border-gray-600 dark:border-white text-gray-600 dark:text-white py-[4px] px-2 rounded text-sm cursor-pointer"
                  phx-click="add_food_hours"
                  phx-target={@myself}
                >
                  <.icon name="hero-plus" class="w-6 h-6 mr-2" /> <%= gettext(
                    "Adicionar novo horário"
                  ) %>
                </a>
              </div>

              <hr />

              <div class="flex w-full justify-center items-center relative mb-10">
                <div
                  class="w-32 h-32 p-[4px] rounded-full justify-center items-center text-gray-500 border-gray-300 flex-col mb-4 text-center relative flex border-dashed"
                  style={"border-width: #{if length(@uploads.vaccination_card.entries) == 0, do: "1px", else: "0px"}"}
                  phx-drop-target={@uploads.vaccination_card.ref}
                >
                  <.live_file_input
                    upload={@uploads.vaccination_card}
                    class="w-full h-full opacity-0 absolute top-0 left-0 cursor-pointer"
                  />

                  <span class="pointer-events-none dark:text-gray-200">
                    <.icon name="hero-camera" class="w-10 h-10" />
                    <br /> <%= gettext("Cartão de vacina") %>
                  </span>

                  <div
                    :for={entry <- @uploads.vaccination_card.entries}
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
                      phx-value-name={:vaccination_card}
                    >
                      <.icon name="hero-x-mark" class="w-5 h-5 dark:text-white" />
                    </a>

                    <div class="absolute bottom-[-36px] left-0 text-center w-full flex justify-center whitespace-nowrap">
                      <.error :for={err <- upload_errors(@uploads.vaccination_card, entry)}>
                        <%= upload_error_to_string(err) %>
                      </.error>
                    </div>
                  </div>
                </div>

                <.error :for={err <- upload_errors(@uploads.vaccination_card)}>
                  <%= upload_error_to_string(err) %>
                </.error>
              </div>

              <div class="w-full flex items-center flex-wrap mt-2">
                <.inputs_for :let={item_medicine} field={@form[:medicines]}>
                  <.field
                    type="text"
                    label={
                      gettext(
                        "%{index}º Remédio",
                        index: item_medicine.index + 1
                      )
                    }
                    field={item_medicine[:name]}
                  />

                  <div class="mr-2" />

                  <.field
                    type="time"
                    label={
                      gettext(
                        "Horário do Remédio",
                        index: item_medicine.index + 1
                      )
                    }
                    field={item_medicine[:hours]}
                  />

                  <a
                    class="p-2 flex justify-center items-center cursor-pointer"
                    phx-click="remove_medicine"
                    phx-target={@myself}
                    phx-value-index={item_medicine.index}
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
                  phx-click="add_medicine"
                  phx-target={@myself}
                >
                  <.icon name="hero-plus" class="w-6 h-6 mr-2" /> <%= gettext(
                    "Adicionar novo remédio"
                  ) %>
                </a>
              </div>

              <.field field={@form[:notes]} type="text" label={gettext("Observações sobre o Pet")} />

              <:actions>
                <.button
                  color="warning"
                  variant="shadow"
                  class="opacity-0 w-[1px] h-[1px] absolute top-0 left-0 pointer-events-none"
                  id="pet-submit-button"
                />
              </:actions>
            </.simple_form>
          </.card_content>
        </.card>
      </ul>

      <.button color="white" variant="outline" class="w-64 mx-auto">
        <.icon name="hero-plus" class="w-6 h-6 mr-2" /> <%= gettext("Adicionar outro Pet") %>
      </.button>

      <.button
        color="warning"
        label={gettext("Continuar")}
        variant="shadow"
        class="mt-24 w-64 mx-auto"
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
    field :name, :string
    field :specie, :string
    field :race, :string
    field :photo, :string
    field :is_natural_food, :boolean, default: false
    field :vaccination_card, :string
    field :notes, :string

    has_many :food_hours, FoodHours
    has_many :medicines, Medicine
  end

  @required_fields [:name, :specie, :race]

  def mount(socket) do
    changeset = build_changeset()

    {:ok,
     socket
     |> assign_form(changeset)
     |> allow_upload(:photo, accept: ~w(.png .jpg .jpeg), max_entries: @max_entries, max_file_size: @max_file_size)
     |> allow_upload(:vaccination_card,
       accept: ~w(.png .jpg .jpeg),
       max_entries: @max_entries,
       max_file_size: @max_file_size
     )
     |> assign(loading: false)}
  end

  def update(%{inn: inn, user_email: user_email}, socket) do
    # user = CheckinController.get_table_cache(:user, user_email)
    species_pet_allowed =
      inn.species_pet_allowed
      |> Enum.at(0)
      |> String.replace(~s("), "")
      |> String.replace(" ", "")
      |> String.split(",")

    {:ok, assign(socket, user_email: user_email, inn: inn, species_pet_allowed: species_pet_allowed)}
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
        {:noreply, assign_form(socket, changeset)}
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

  def handle_event("add_food_hours", _, socket) do
    changeset =
      EctoNestedChangeset.append_at(socket.assigns.form.source, :food_hours, %{})

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("remove_food_hours", %{"index" => index}, socket) do
    index = String.to_integer(index)

    changeset =
      EctoNestedChangeset.delete_at(
        socket.assigns.form.source,
        [:food_hours, index],
        mode: {:flag, :delete}
      )

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("add_medicine", _, socket) do
    changeset =
      EctoNestedChangeset.append_at(socket.assigns.form.source, :medicines, %{})

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("remove_medicine", %{"index" => index}, socket) do
    index = String.to_integer(index)

    changeset =
      EctoNestedChangeset.delete_at(
        socket.assigns.form.source,
        [:medicines, index],
        mode: {:flag, :delete}
      )

    {:noreply, assign_form(socket, changeset)}
  end

  defp assign_form(socket, changeset) do
    assign(socket, form: to_form(changeset, as: :object))
  end

  defp build_changeset(params \\ %{}) do
    %__MODULE__{food_hours: [], medicines: []}
    |> Ecto.Changeset.cast(params, @required_fields)
    |> Ecto.Changeset.cast_assoc(:food_hours,
      required: false,
      with: &FoodHours.changeset/2
    )
    |> Ecto.Changeset.cast_assoc(:medicines, required: false, with: &Medicine.changeset/2)
    |> Ecto.Changeset.validate_required(:name, message: "É necessário inserir um nome")
    |> Ecto.Changeset.validate_required(:specie, message: "É necessário selecionar uma espécie")
    |> Ecto.Changeset.validate_required(:race, message: "É necessário inserir um nome de raça")
  end

  defp validate_changeset(changeset) do
    Ecto.Changeset.apply_action(changeset, :validate)
  end

  defp handle_file_upload(socket, name) do
    [file_path] =
      consume_uploaded_entries(socket, name, fn %{path: path}, entry ->
        path_with_extension = path <> String.replace(entry.client_type, "image/", ".")
        dest = Path.join(Application.app_dir(:pet_inn, "priv/static/uploads"), Path.basename(path_with_extension))
        File.cp!(path, dest)
        {:ok, ~p"/uploads/#{Path.basename(dest)}"}
      end)

    file_path
  end

  defp submit_step(socket, changeset, params) do
    IO.inspect(params)
    # photo_path = if length(socket.assigns.uploads.photo.entries) > 0, do: handle_file_upload(socket, :photo)

    # vaccination_card_path =
    #   if length(socket.assigns.uploads.vaccination_card.entries) > 0, do: handle_file_upload(socket, :vaccination_card)

    # IO.inspect(params)
    # IO.inspect(photo_path)
    # IO.inspect(vaccination_card_path)

    {:noreply, socket |> assign_form(changeset) |> assign(loading: true)}
  end

  defp upload_error_to_string(:too_many_files), do: gettext("Permitido somente 1 arquivo.")
  defp upload_error_to_string(:too_large), do: gettext("Arquivo muito grande.")
  defp upload_error_to_string(:not_accepted), do: gettext("Tipo de arquivo não aceito.")
  defp upload_error_to_string(:external_client_failure), do: gettext("Algo deu errado.")
end
