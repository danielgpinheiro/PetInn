defmodule PetInnWeb.Shared.Wizard.StepperComponent do
  use PetInnWeb, :live_component

  def render(assigns) do
    ~H"""
    <div
      class="min-w-[40%] max-w-[70%] mb-6"
      style={"width:" <> Integer.to_string(Enum.count(@steps) * 10) <> "%"}
    >
      <div class="w-full h-1 bg-gray-200 rounded">
        <div
          class="h-full bg-gradient-to-r from-orange-200 to-orange-600 max-w-[100%] relative
        rounded after:content-[''] after:w-2 after:h-2 after:rounded after:absolute after:top-[-2px] after:right-[-2px] after:bg-orange-600 transition-width duration-700 ease-out will-change-width"
          style={"width: #{if @current_step + 1 === Enum.count(@steps), do: "100%", else: Float.to_string((100 / Enum.count(@steps) * (@current_step + 1)) - (100 / Enum.count(@steps) / 2)) <> "%"}"}
        >
          <span class="text-orange-600 absolute top-[-25px] right-0 text-xs whitespace-nowrap translate-x-1/2">
            <%= Enum.at(@steps, @current_step).title %>
          </span>
        </div>
      </div>
      
      <ul class="w-full flex justify-between mt-2">
        <%= for step <- @steps do %>
          <li
            class="flex justify-center"
            style={"width:" <> Float.to_string(100 / Enum.count(@steps)) <> "%"}
          >
            <button class="w-full" disabled={step.index >= @current_step}>
              <.icon
                name={step.icon}
                class={
                  "
                    w-6 transition-colors
                    #{if step.index === @current_step do "bg-orange-600" end}
                    #{if step.index < @current_step do "bg-orange-400" end}
                    #{if step.index > @current_step do "bg-gray-400" end}
                  "
                }
              />
            </button>
          </li>
        <% end %>
      </ul>
    </div>
    """
  end

  def mount(socket) do
    {:ok, socket}
  end

  def update(%{steps: steps, current_step: current_step} = _assigns, socket) do
    {:ok,
     socket
     |> assign(steps: steps)
     |> assign(current_step: current_step)}
  end
end
