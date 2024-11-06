defmodule PetInnWeb.Shared.Checkin.Steps.PetComponent do
  @moduledoc false
  use PetInnWeb, :live_component

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
                <%!-- <.field type="time" label={gettext("1º Horário da Alimentação")} field={@form[:name]} /> --%>

                <a class="p-2 flex justify-center items-center cursor-pointer">
                  <.icon name="hero-plus-circle" />
                </a>
              </div>

              <.field
                type="switch"
                label={gettext("Alimentação é comida natural?")}
                field={@form[:is_natural_food]}
              />

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

              <:actions>
                <.button
                  color="warning"
                  variant="shadow"
                  class="opacity-0 w-[1px] h-[1px] absolute top-0 left-0 pointer-events-none"
                  id="pet-submit-button"
                />
              </:actions>
            </.simple_form>

            <%!--
            <div class="w-full flex items-center flex-wrap mt-2">
              <label class="input input-bordered flex items-center gap-2 w-48 pr-0 relative mb-2 mr-2">
                <span class="label-text absolute bottom-[100%] left-0">
                  1º Horário da Alimentação
                </span>
                <.icon name="hero-clock" class="h-5 w-5 opacity-70 shrink-0" />
                <input type="time" class="w-full text-gray-500 text-base" />
              </label>

              <button class="p-2 flex justify-center items-center mt-[-8px]">
                <.icon name="hero-plus-circle" />
              </button>
            </div>

            <div class="form-control w-52 self-start">
              <label class="label cursor-pointer">
                <span class="label-text">Alimentação é comida natural?</span>
                <input type="checkbox" class="toggle toggle-warning" checked="checked" />
              </label>
            </div>

            <div class="divider"></div>

            <button class="w-24 h-30 p-[4px] bg-white rounded-lg justify-center items-center text-gray-500 border-[1px] border-gray-300 flex-col mb-8">
              <span>
                <.icon name="hero-camera" class="w-10 h-10" /> <br /> Foto do cartão de vacina
              </span>
            </button>

            <div class="w-full flex">
              <label class="input input-bordered flex items-center gap-2 w-1/2 relative mr-2">
                <span class="label-text absolute bottom-[100%] left-0">
                  1º Remédio
                </span>
                <input type="text" class="w-full" placeholder="Nome do Remédio" />
              </label>

              <label class="input input-bordered flex items-center gap-2 w-48 pr-0 relative mb-2 mr-2">
                <span class="label-text absolute bottom-[100%] left-0">
                  Horário do Remédio
                </span>
                <.icon name="hero-clock" class="h-5 w-5 opacity-70 shrink-0" />
                <input type="time" class="w-full text-gray-500 text-base" />
              </label>

              <button class="p-2 flex justify-center items-center mt-[-8px]">
                <.icon name="hero-plus-circle" />
              </button>
            </div>
            <textarea
              class="textarea textarea-bordered w-full"
              placeholder="Observações sobre o Pet"
            ></textarea> --%>
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

  def mount(socket) do
    changeset = build_changeset()

    {:ok,
     socket
     |> assign_form(changeset)
     |> allow_upload(:photo, accept: ~w(.png .jpg .jpeg), max_entries: @max_entries, max_file_size: @max_file_size)
     |> allow_upload(:vaccination_card,
       accept: ~w(.png .jpg .jpeg .pdf),
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
    IO.inspect(object_params)

    {:noreply, socket}
  end

  def handle_event("cancel", %{"ref" => ref, "name" => name}, socket) do
    {:noreply, cancel_upload(socket, String.to_atom(name), ref)}
  end

  def handle_event("submit", %{"object" => object_params}, socket) do
    IO.inspect(object_params)

    handle_file_upload(socket)

    {:noreply, socket}
  end

  def handle_event("trigger_button", %{"button_id" => button_id}, socket) do
    {:noreply,
     push_event(
       socket,
       "trigger_button",
       %{button_id: button_id}
     )}
  end

  defp assign_form(socket, changeset) do
    assign(socket, form: to_form(changeset, as: :object))
  end

  defp build_changeset(params \\ %{}) do
    data = %{}

    types = %{
      photo: :string,
      vaccination_card: :string,
      name: :string,
      specie: :string,
      race: :string,
      is_natural_food: :boolean
    }

    Ecto.Changeset.cast({data, types}, params, Map.keys(types))
  end

  defp validate_changeset(changeset) do
    Ecto.Changeset.apply_action(changeset, :validate)
  end

  defp handle_file_upload(socket) do
    [file_path] =
      consume_uploaded_entries(socket, :photo, fn %{path: path}, entry ->
        path_with_extension = path <> String.replace(entry.client_type, "image/", ".")
        dest = Path.join(Application.app_dir(:pet_inn, "priv/static/uploads"), Path.basename(path_with_extension))
        File.cp!(path, dest)
        {:ok, ~p"/uploads/#{Path.basename(dest)}"}
      end)

    file_path
  end

  defp upload_error_to_string(:too_many_files), do: gettext("Permitido somente 1 arquivo.")
  defp upload_error_to_string(:too_large), do: gettext("Arquivo muito grande.")
  defp upload_error_to_string(:not_accepted), do: gettext("Tipo de arquivo não aceito.")
  defp upload_error_to_string(:external_client_failure), do: gettext("Algo deu errado.")
end
