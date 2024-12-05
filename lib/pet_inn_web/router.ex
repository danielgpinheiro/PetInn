defmodule PetInnWeb.Router do
  use PetInnWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {PetInnWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  live_session :default do
    scope "/", PetInnWeb do
      pipe_through :browser

      get "/", RedirectController, :index

      live "/checkin/:inn_id", CheckinLive, :checkin
      live "/checkout", CheckoutLive, :checkout
      live "/confirm/:inn_id/:user_id", ConfirmLive, :confirm
      live "/404", FourOhFourLive, :four_oh_four
    end
  end

  live_session :admin, layout: {PetInnWeb.AdminLayout, :render} do
    scope "/admin", PetInnWeb do
      pipe_through :browser

      live "/booking", Admin.BookingLive, :booking
      live "/rating", Admin.RatingLive, :rating
      live "/generate", Admin.GenerateLive, :generate
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", PetInnWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development=
  if Application.compile_env(:pet_inn, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: PetInnWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  scope "/", PetInnWeb do
    pipe_through :browser

    get "/*path", FourOhFourController, :index
  end
end
