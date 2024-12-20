defmodule PetInnWeb.ConfirmLive do
  @moduledoc false
  use PetInnWeb, :live_view

  alias PetInnWeb.InnController
  alias PetInnWeb.Shared.Confirm.Steps.ConfirmationComponent
  alias PetInnWeb.Shared.Confirm.Steps.SelectDateComponent
  alias PetInnWeb.Shared.FooterComponent
  alias PetInnWeb.Shared.Header.HeaderComponent
  alias PetInnWeb.Shared.Wizard.WizardStructureComponent
  alias PetInnWeb.UserController

  def render(assigns) do
    ~H"""
    <section id="confirmation" class="w-full h-full bg-white dark:bg-gray-800 relative">
      <div
        :if={@inn.loading}
        class="w-full h-screen absolute top-0 left-0 z-10 flex justify-center items-center bg-black dark:bg-gray-500 bg-opacity-10"
      >
        <.spinner size="lg" class="text-primary-500" />
      </div>

      <div :if={@inn.ok? && @inn.result && @user.ok? && @user.result}>
        <.live_component module={HeaderComponent} id={:header} inn={@inn.result} />
        <div class="w-full relative min-h-[calc(100vh-173px)] p-3">
          <.live_component
            module={WizardStructureComponent}
            id={:wizard}
            steps={@steps}
            inn={@inn.result}
            user={@user.result}
          />
        </div>
        <.live_component module={FooterComponent} id={:footer} />
      </div>

      <div :if={(@inn.ok? && @inn.result === nil) || (@user.ok? && @user.result === nil)}>
        Algo de errado não está certo!
      </div>

      <div :if={(!@inn.ok? && @inn.result === nil) || (!@user.ok? && @user.result === nil)}>
        Algo de errado não está certo! 2
      </div>
    </section>
    """
  end

  def mount(params, _session, socket) do
    locale = Map.fetch(params, "locale")
    inn_id = Map.fetch!(params, "inn_id")
    user_id = Map.fetch!(params, "user_id")

    case locale do
      {:ok, value} -> Gettext.put_locale(value)
      :error -> Gettext.put_locale("pt_BR")
    end

    {:ok,
     socket
     |> assign_async(:inn, fn -> {:ok, %{inn: InnController.get_inn(inn_id)}} end)
     |> assign_async(:user, fn -> {:ok, %{user: UserController.get_by_user_id(user_id)}} end)
     |> assign(inn_id: inn_id)
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
