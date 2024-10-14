defmodule PetInnWeb.Admin.GenerateLive do
  use PetInnWeb, :live_view

  alias Phoenix.LiveView.JS

  def render(assigns) do
    ~H"""
    <section class="w-full h-full overflow-hidden py-4 flex flex-col items-center" id="generate">
      <h1 class="text-center text-lg text-gray-800 mb-11">
        Mande esse QRCode ou o link abaixo para o seus clientes fazerem o Check-In Online do Pet
      </h1>
       <canvas id="qrcode" phx-hook="QRCode"></canvas>
      <label
        class="input input-bordered flex items-center gap-2 max-w-xs"
        id="clipboard-input"
        phx-hook="Clipboard"
      >
        <input
          type="text"
          class="grow"
          value="http://localhost:4000/admin/generate"
          id="text-to-clipboard"
        />
        <button phx-click={JS.dispatch("pet_inn:clipboard")}>
          <.icon name="hero-clipboard-document" class="h-6 w-6 opacity-90" />
        </button>
      </label>
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
     push_event(
       socket,
       "generate_qr_code",
       %{text: "http://localhost:4000/admin/generate"}
     )}
  end
end
