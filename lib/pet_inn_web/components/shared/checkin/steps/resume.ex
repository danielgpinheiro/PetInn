defmodule PetInnWeb.Shared.Checkin.Steps.ResumeComponent do
  use PetInnWeb, :live_component

  alias PetInnWeb.Shared.Wizard.WizardStructureComponent

  def render(assigns) do
    ~H"""
    <div class="w-full sm:w-[600px] flex flex-col justify-center mx-auto">
      <h1 class="text-center text-lg text-gray-800 mb-11">
        Confira se todos os dados estão corretos, caso não, é possivel edita-los no botão Editar Informações
      </h1>
      
      <div class="w-full flex justify-between mb-12 flex-wrap sm:flex-nowrap">
        <div class="card bg-base-100 shadow-xl w-full mb-4 sm:mb-0 sm:w-[calc(50%-20px)]">
          <div class="card-body flex flex-col">
            <h3 class="font-bold">Dados Pessoais</h3>
             <span><strong>Email:</strong> lorem@lorem.com.br</span>
            <span><strong>Telefone:</strong> lorem@lorem.com.br</span>
            <span><strong>Nome Completo:</strong> lorem@lorem.com.br</span>
            <span><strong>Data de Nascimento:</strong> lorem@lorem.com.br</span>
            <span><strong>Gênero:</strong> lorem@lorem.com.br</span>
            <span><strong>Profissão:</strong> lorem@lorem.com.br</span>
            <div class="divider"></div>
             <span><strong>CEP:</strong> lorem@lorem.com.br</span>
            <span><strong>País:</strong> lorem@lorem.com.br</span>
            <span><strong>Estado:</strong> lorem@lorem.com.br</span>
            <span><strong>CIdade:</strong> lorem@lorem.com.br</span>
            <span><strong>Bairro:</strong> lorem@lorem.com.br</span>
            <span><strong>Logradouro:</strong> lorem@lorem.com.br</span>
            <span><strong>Número:</strong> lorem@lorem.com.br</span>
            <span><strong>Complemento:</strong> lorem@lorem.com.br</span>
          </div>
        </div>
        
        <div class="card bg-base-100 shadow-xl w-full sm:w-[calc(50%-20px)]">
          <div class="card-body flex flex-col">
            <h3 class="font-bold">Dados do Pet</h3>
             <span><strong>Nome:</strong> lorem@lorem.com.br</span>
            <span><strong>Espécie:</strong> lorem@lorem.com.br</span>
            <span><strong>Raça:</strong> lorem@lorem.com.br</span>
            <span><strong>Alimentação:</strong> lorem@lorem.com.br</span>
            <span><strong>Comida Natural:</strong> Sim</span>
            <span><strong>Remédios:</strong> lorem@lorem.com.br</span>
            <span><strong>Observações:</strong> lorem@lorem.com.br</span>
            <div class="divider"></div>
          </div>
        </div>
      </div>
      
      <div class="card bg-base-100 w-full shadow-xl overflow-hidden mb-20">
        <iframe
          src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3774.214218902722!2d-48.2706447240907!3d-18.92190988225115!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x94a445e0ba073833%3A0x41e8ec062bf3a488!2sSanto%20Chico%20Pet!5e0!3m2!1spt-BR!2sbr!4v1728676206895!5m2!1spt-BR!2sbr"
          width="100%"
          height="450"
          style="border:0;"
          allowfullscreen=""
          loading="lazy"
          referrerpolicy="no-referrer-when-downgrade"
        >
        </iframe>
        <div class="card-body">
          <h2 class="card-title">Endereço do Santo Chico Hotel Pet</h2>
          
          <p>R. Guajajaras, 791 - Saraiva, Uberlândia - MG, 38408-406</p>
        </div>
      </div>
       <button class="btn btn-wide mx-auto">Editar Informações</button>
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
