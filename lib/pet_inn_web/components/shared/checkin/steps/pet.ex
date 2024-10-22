defmodule PetInnWeb.Shared.Checkin.Steps.PetComponent do
  @moduledoc false
  use PetInnWeb, :live_component

  alias PetInnWeb.CheckinController
  alias PetInnWeb.Shared.Wizard.WizardStructureComponent

  def render(assigns) do
    ~H"""
    <div class="w-[650px] mx-auto flex justify-center flex-col">
      <h1 class="text-center text-lg text-gray-800 mb-11">
        Insira os dados do seu Pet, para entendermos quais as necessidades do seu Pet na Estadia.
      </h1>
      
      <ul class="mx-auto mb-12">
        <li class="w-full card bg-base-100 shadow-xl">
          <div class="card-body flex flex-col items-center w-full relative">
            <div class="card-actions absolute top-2 right-2">
              <button class="btn btn-square btn-sm">
                <.icon name="hero-x-mark" class="w-6 h-6" />
              </button>
            </div>
            
            <button class="w-24 h-24 p-[4px] bg-white rounded-lg justify-center items-center text-gray-500 border-[1px] border-gray-300 flex-col mb-4">
              <%!-- <img src="/images/pet.jpg" class="w-full rounded" /> --%>
              <span>
                <.icon name="hero-camera" class="w-10 h-10" /> <br /> Foto do Pet
              </span>
            </button>
            
            <div class="w-full flex justify-between">
              <label class="input input-bordered flex items-center gap-2 w-48 mr-2">
                <input type="text" class="w-full" placeholder="Nome do Pet" />
              </label>
              
              <label class="input input-bordered flex items-center gap-2 w-48 pr-0 mr-2">
                <select class="select select-bordered w-full max-w-xs h-[calc(3rem-2px)] min-h-[calc(3rem-2px)] text-gray-500 text-base">
                  <option disabled selected>Espécie</option>
                  
                  <option>Cachorro</option>
                  
                  <option>Gato</option>
                  
                  <option>Avés</option>
                  
                  <option>Répteis</option>
                  
                  <option>Roedores</option>
                </select>
              </label>
              
              <label class="input input-bordered flex items-center gap-2 w-48">
                <input type="text" class="w-full" placeholder="Raça" />
              </label>
            </div>
            
            <div class="divider"></div>
            
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
            ></textarea>
          </div>
        </li>
      </ul>
      
      <button class="btn btn-wide mx-auto">
        <.icon name="hero-plus" class="w-6 h-6" /> Adicionar outro Pet
      </button>
    </div>
    """
  end

  def mount(socket) do
    {:ok, socket}
  end

  # def update(%{inn_id: inn_id, user_email: user_email}, socket) do
  #   user = CheckinController.get_table_cache(:user, user_email)

  #   IO.inspect(user)

  #   {:ok, socket |> assign(user_email: user_email, inn_id: inn_id)}
  # end

  def update(_, socket) do
    {:ok, socket}
  end
end
