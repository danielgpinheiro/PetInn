defmodule PetInnWeb.CheckinLive do
  use PetInnWeb, :live_view

  alias PetInnWeb.Shared.Header.HeaderComponent
  alias PetInnWeb.Shared.Wizard.WizardStructureComponent
  alias PetInnWeb.Shared.FooterComponent

  alias PetInnWeb.Shared.Checkin.Steps.VerifyComponent
  alias PetInnWeb.Shared.Checkin.Steps.RegistrationComponent
  alias PetInnWeb.Shared.Checkin.Steps.PetComponent
  alias PetInnWeb.Shared.Checkin.Steps.AddressComponent
  alias PetInnWeb.Shared.Checkin.Steps.ResumeComponent
  alias PetInnWeb.Shared.Checkin.Steps.ConfirmationComponent

  def render(assigns) do
    ~H"""
    <section id="checkin" class="w-full h-full">
      <.live_component module={HeaderComponent} id={:header} />
      <div class="w-full relative min-h-[calc(100vh-175px)] p-3">
        <.live_component module={WizardStructureComponent} id={:wizard} steps={@steps} />
      </div>
       <.live_component module={FooterComponent} id={:footer} />
    </section>
    """
  end

  def mount(params, _session, socket) do
    locale = Map.fetch(params, "locale")

    case locale do
      {:ok, value} -> Gettext.put_locale(value)
      :error -> Gettext.put_locale("pt_BR")
    end

    {:ok,
     socket
     |> assign(
       steps: [
         %WizardStructureComponent{
           title: gettext("Identificação"),
           icon: "hero-at-symbol-solid",
           component: VerifyComponent
         },
         %WizardStructureComponent{
           title: gettext("Dados Cadastrais"),
           icon: "hero-identification-solid",
           component: RegistrationComponent
         },
         %WizardStructureComponent{
           title: gettext("Dados do Pet"),
           icon: "hero-heart-solid",
           component: PetComponent
         },
         %WizardStructureComponent{
           title: gettext("Endereço"),
           icon: "hero-map-pin-solid",
           component: AddressComponent
         },
         %WizardStructureComponent{
           title: gettext("Resumo"),
           icon: "hero-list-bullet-solid",
           component: ResumeComponent
         },
         %WizardStructureComponent{
           title: gettext("Confirmação"),
           icon: "hero-check-circle-solid",
           component: ConfirmationComponent
         }
       ]
     )}
  end
end
