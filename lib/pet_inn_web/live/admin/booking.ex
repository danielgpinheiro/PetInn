defmodule PetInnWeb.Admin.BookingLive do
  use PetInnWeb, :live_view

  def render(assigns) do
    ~H"""
    <section class="w-full h-full overflow-y-auto">
      Lorem ipsum dolor sit amet consectetur adipisicing elit. Sint quos quidem soluta dicta quia necessitatibus temporibus laboriosam fugit, molestiae recusandae consequuntur obcaecati, beatae velit ducimus?
    </section>
    """
  end

  def mount(params, _session, socket) do
    locale = Map.fetch(params, "locale")

    case locale do
      {:ok, value} -> Gettext.put_locale(value)
      :error -> Gettext.put_locale("pt_BR")
    end

    {:ok, socket}
  end
end
