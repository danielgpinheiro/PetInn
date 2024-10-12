defmodule PetInnWeb.Shared.Checkin.Steps.VerifyComponent do
  use PetInnWeb, :live_component

  alias PetInnWeb.Shared.Wizard.WizardStructureComponent

  def render(assigns) do
    ~H"""
    <div class="w-full sm:w-[550px] mx-auto flex flex-col justify-center items-center">
      <h1 class="text-center text-lg text-gray-800 mb-11">
        Em pouco tempo, o cadastro de você e do seu Pet será feito.<br />
        Após isso, você poderá reutilizar seu registro em outros lugares com o ecosistema Pet Inns.
      </h1>
      
      <label class="input input-bordered flex items-center gap-2 mb-9 w-full sm:w-3/4">
        <.icon name="hero-envelope" class="h-5 w-5 opacity-70" />
        <input type="text" class="grow" placeholder="Email" />
      </label>
      
      <.live_component
        module={LivePhone}
        id="phone"
        form={:user}
        field={:phone}
        tabindex={0}
        preferred={["BR", "US", "ES"]}
        placeholder="Número de Telefone"
      />
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
