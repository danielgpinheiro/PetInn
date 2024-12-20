defmodule PetInnWeb.CheckinLive do
  @moduledoc false
  use PetInnWeb, :live_view

  alias PetInnWeb.InnController
  alias PetInnWeb.Shared.Checkin.Steps.AddressComponent
  alias PetInnWeb.Shared.Checkin.Steps.ConfirmationComponent
  alias PetInnWeb.Shared.Checkin.Steps.Pet.PetComponent
  alias PetInnWeb.Shared.Checkin.Steps.RegistrationComponent
  alias PetInnWeb.Shared.Checkin.Steps.ResumeComponent
  alias PetInnWeb.Shared.Checkin.Steps.VerifyComponent
  alias PetInnWeb.Shared.FooterComponent
  alias PetInnWeb.Shared.Header.HeaderComponent
  alias PetInnWeb.Shared.Wizard.WizardStructureComponent

  def render(assigns) do
    ~H"""
    <section id="checkin" class="w-full h-full bg-white dark:bg-gray-800 relative">
      <div
        :if={@inn.loading}
        class="w-full h-screen absolute top-0 left-0 z-10 flex justify-center items-center bg-black dark:bg-gray-500 bg-opacity-10"
      >
        <.spinner size="lg" class="text-primary-500" />
      </div>
      
      <div :if={inn = @inn.ok? && @inn.result}>
        <.live_component module={HeaderComponent} id={:header} inn={inn} />
        <div class="w-full relative min-h-[calc(100vh-175px)] p-3">
          <.live_component
            module={WizardStructureComponent}
            id={:wizard}
            steps={@steps}
            inn={inn}
            user={nil}
          />
        </div>
         <.live_component module={FooterComponent} id={:footer} />
      </div>
      
      <div :if={@inn.ok? && @inn.result === nil}>
        Algo de errado não está certo!
      </div>
      
      <div :if={!@inn.ok? && @inn.result === nil}>
        Algo de errado não está certo! 2
      </div>
    </section>
    """
  end

  def mount(params, _session, socket) do
    locale = Map.fetch(params, "locale")
    inn_id = Map.fetch!(params, "inn_id")

    case locale do
      {:ok, value} -> Gettext.put_locale(value)
      :error -> Gettext.put_locale("pt_BR")
    end

    {:ok,
     socket
     |> assign_async(:inn, fn -> {:ok, %{inn: InnController.get_inn(inn_id)}} end)
     |> assign(inn_id: inn_id)
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

  def handle_info({:update_flash, {flash_type, msg}}, socket) do
    {:noreply, put_flash(socket, flash_type, msg)}
  end
end
