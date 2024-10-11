defmodule PetInnWeb.Shared.Checkin.Steps.RegistrationComponent do
  use PetInnWeb, :live_component

  alias PetInnWeb.Shared.Wizard.WizardStructureComponent

  def render(assigns) do
    ~H"""
    <div class="w-[700px] mx-auto flex flex-col justify-center items-center">
      <h1 class="text-center text-lg text-gray-800 mb-11">
        <strong>Olá, bem vindo!</strong> <br />
        Continue o cadastro de você e do seu Pet para reservar uma estadia.
      </h1>
      
      <label class="input input-bordered flex items-center gap-2 mb-9 w-3/4">
        <.icon name="hero-user" class="h-5 w-5 opacity-70" />
        <input type="text" class="grow" placeholder="Nome Completo" />
      </label>
      
      <div class="flex justify-between w-3/4 mb-9">
        <label class="input input-bordered flex items-center gap-2 w-[48%]">
          <.icon name="hero-calendar" class="h-5 w-5 opacity-70 shrink-0" />
          <input type="date" class="grow text-gray-500 text-base" placeholder="Data de Nascimento" />
        </label>
        
        <label class="input input-bordered flex items-center gap-2 w-[48%] pr-0">
          <.icon name="hero-user-group" class="h-5 w-5 opacity-70 shrink-0" />
          <select class="select select-bordered w-full max-w-xs h-[calc(3rem-2px)] min-h-[calc(3rem-2px)] text-gray-500 text-base">
            <option disabled selected>Gênero</option>
            
            <option>Masculino</option>
            
            <option>Feminino</option>
          </select>
        </label>
      </div>
      
      <label class="input input-bordered flex items-center gap-2 mb-9 w-3/4">
        <.icon name="hero-briefcase" class="h-5 w-5 opacity-70" />
        <input type="text" class="grow" placeholder="Profissão" />
      </label>
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
