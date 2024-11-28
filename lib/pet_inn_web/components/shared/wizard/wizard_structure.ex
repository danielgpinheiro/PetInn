defmodule PetInnWeb.Shared.Wizard.WizardStructureComponent do
  @moduledoc false
  use PetInnWeb, :live_component

  alias PetInnWeb.Shared.Wizard.StepperComponent

  @required_keys [:title, :icon, :component]
  @enforce_keys @required_keys
  defstruct @required_keys

  def render(assigns) do
    ~H"""
    <div id={:wizard} class="w-full flex justify-center items-center flex-col sm:p-6 relative">
      <button
        phx-click="previous_step"
        phx-target={@myself}
        class={"absolute top-[-55px] left-0 sm:top-10 sm:left-10 flex items-center text-orange-600 transition-opacity" <> (if @current_step === 0, do: " opacity-0 pointer-events-none", else: "")}
      >
        <.icon name="hero-arrow-left" class="w-5 h-5 mr-2" /> Voltar
      </button>

      <.live_component
        module={StepperComponent}
        id={:stepper}
        steps={@steps}
        current_step={@current_step}
      />
      <div class="w-full mt-10 mb-20 wizard-animate-content" id={:wizard_step_content}>
        <.live_component
          module={Enum.at(@steps, @current_step).component}
          id={:step}
          inn={@inn}
          user_email={@user_email}
        />
      </div>
    </div>
    """
  end

  def mount(socket) do
    {:ok, socket}
  end

  def update(%{steps: steps, inn: inn} = _assigns, socket) do
    {:ok,
     socket
     |> assign(steps: steps)
     |> assign(current_step: 4)
     |> assign(inn: inn)
     |> assign(user_email: "")}
  end

  def update(
        %{action: :can_continue, user_email: user_email},
        %{assigns: %{current_step: current_step} = _assigns} = socket
      ) do
    {:ok,
     push_event(
       assign(socket, current_step: current_step + 1, user_email: user_email),
       "scroll_to_element",
       %{element: "body", top: 0, left: 0, behavior: "instant", fade_wizard: true}
     )}
  end

  def update(%{action: :go_to_step, step: step}, socket) do
    {:ok, assign(socket, current_step: String.to_integer(step))}
  end

  def update(_, socket) do
    {:ok, socket}
  end

  def handle_event("previous_step", _params, %{assigns: %{current_step: current_step} = _assigns} = socket) do
    {:noreply,
     push_event(
       assign(socket, current_step: current_step - 1),
       "scroll_to_element",
       %{element: "body", top: 0, left: 0, behavior: "instant", c: true}
     )}
  end
end
