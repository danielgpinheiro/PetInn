defmodule PetInnWeb.Shared.Wizard.WizardStructureComponent do
  use PetInnWeb, :live_component

  alias PetInnWeb.Shared.Wizard.StepperComponent

  @required_keys [:title, :icon, :component]
  @enforce_keys @required_keys
  defstruct @required_keys

  def render(assigns) do
    ~H"""
    <div
      id={:wizard}
      phx-hook="ScrollToElement"
      class="w-full flex justify-center items-center flex-col p-6 relative"
    >
      <button
        phx-click="previous_step"
        phx-target={@myself}
        class={"absolute top-5 left-10 flex items-center text-orange-600 transition-opacity" <> (if @current_step === 0, do: " opacity-0 pointer-events-none", else: "")}
      >
        <.icon name="hero-arrow-left" class="w-5 h-5 mr-2" /> Voltar
      </button>
      
      <.live_component
        module={StepperComponent}
        id={:stepper}
        steps={@steps}
        current_step={@current_step}
      />
      <div class="w-full mt-10 mb-20 wizard-animate-content">
        <.live_component module={Enum.at(@steps, @current_step).component} id={:step} />
      </div>
      
      <%= if !@final_step do %>
        <button
          class="btn btn-wide bg-orange-600 text-white"
          phx-click="next_step"
          phx-target={@myself}
        >
          Continuar
        </button>
      <% end %>
    </div>
    """
  end

  def mount(socket) do
    {:ok, socket}
  end

  def update(%{steps: steps} = _assigns, socket) do
    {:ok,
     socket
     |> assign(steps: steps)
     |> assign(previous_step: 0)
     |> assign(current_step: 5)
     |> assign(final_step: false)
     |> assign(loading: false)}
  end

  def update(
        %{action: :can_continue},
        %{assigns: %{current_step: current_step, steps: steps} = _assigns} = socket
      ) do
    {:ok,
     socket
     |> assign(
       previous_step: current_step - 1,
       current_step: current_step + 1,
       final_step: Enum.count(steps) === current_step + 2
     )}
  end

  def update(_, socket) do
    {:ok, socket}
  end

  def handle_event(
        "previous_step",
        _params,
        %{assigns: %{current_step: current_step, steps: steps} = _assigns} = socket
      ) do
    {:noreply,
     push_event(
       socket
       |> assign(
         current_step: current_step - 1,
         final_step: Enum.count(steps) === current_step - 2
       ),
       "scrollTo-element",
       %{element: "body"}
     )}
  end

  def handle_event(
        "next_step",
        _params,
        %{assigns: %{steps: steps, current_step: current_step} = _assigns} = socket
      ) do
    send_update(Enum.at(steps, current_step).component, %{id: :step, action: :submit})

    {:noreply,
     push_event(
       socket,
       "scrollTo-element",
       %{element: "body"}
     )}
  end
end
