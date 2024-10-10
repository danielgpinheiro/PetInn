defmodule PetInnWeb.CheckinLive do
  use PetInnWeb, :live_view

  alias PetInnWeb.Shared.HeaderComponent
  alias PetInnWeb.Shared.Wizard.WizardStructureComponent
  alias PetInnWeb.Shared.FooterComponent

  alias PetInnWeb.Shared.Checkin.Steps.VerifyComponent
  alias PetInnWeb.Shared.Checkin.Steps.RegistrationComponent
  alias PetInnWeb.Shared.Checkin.Steps.PetComponent

  def render(assigns) do
    ~H"""
    <section id="checkin" class="w-full h-full border-[1px] border-red-500">
      <.live_component module={HeaderComponent} id={:header} />
      <div class="w-full relative min-h-[calc(100vh-175px)] p-3">
        <.live_component module={WizardStructureComponent} id={:wizard} steps={@steps} />
      </div>
       <.live_component module={FooterComponent} id={:footer} />
    </section>
    """
  end

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(
       steps: [
         %WizardStructureComponent{
           title: "Identificacão",
           icon: "hero-at-symbol-solid",
           component: VerifyComponent
         },
         %WizardStructureComponent{
           title: "Dados Cadastrais",
           icon: "hero-identification-solid",
           component: RegistrationComponent
         },
         %WizardStructureComponent{
           title: "Dados do Pet",
           icon: "hero-heart-solid",
           component: PetComponent
         }
       ]
     )}
  end
end
