defmodule PetInnWeb.Shared.Checkin.Steps.AddressComponent do
  @moduledoc false
  use PetInnWeb, :live_component

  alias PetInnWeb.Shared.Wizard.WizardStructureComponent

  def render(assigns) do
    ~H"""
    <div class="w-full sm:w-[500px] flex flex-col mx-auto">
      <div class="w-full flex flex-col items-center">
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
      </div>
    </div>
    """
  end

  def mount(socket) do
    {:ok, socket}
  end

  def update(%{action: :submit}, socket) do
    IO.inspect("opa submeti")

    send_update(WizardStructureComponent, %{id: :wizard, action: :can_continue})

    {:ok, socket}
  end

  def update(_, socket) do
    {:ok, socket}
  end
end
