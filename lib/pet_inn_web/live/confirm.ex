defmodule PetInnWeb.ConfirmLive do
  use PetInnWeb, :live_view

  alias PetInnWeb.Shared.Header.HeaderComponent
  alias PetInnWeb.Shared.Wizard.WizardStructureComponent
  alias PetInnWeb.Shared.FooterComponent

  alias PetInnWeb.Shared.Confirm.Steps.SelectDateComponent
  alias PetInnWeb.Shared.Confirm.Steps.ConfirmationComponent

  def render(assigns) do
    ~H"""
    <section id="dates" class="w-full h-full">
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
           title: gettext("Selecionar Data"),
           icon: "hero-calendar-days-solid",
           component: SelectDateComponent
         },
         %WizardStructureComponent{
           title: gettext("Confirmação"),
           icon: "hero-check-badge-solid",
           component: ConfirmationComponent
         }
       ]
     )}
  end
end
