defmodule RadioWeb.Router do
  use RadioWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {RadioWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  # TODO: Finalize user management
  #scope "/", RadioWeb do
  #  pipe_through :browser

  # get "/", LoginController, :show
  #  get "/auth/google/callback", GoogleAuthController, :index
  #end

  #scope "/player", RadioWeb do
  #  pipe_through :browser

  #  live "/:name", RadioPlayer
  #end

  scope "/", RadioWeb do
    pipe_through :browser

    live "/", RadioPlayer
  end

  #scope "/api", RadioWeb do
  #  pipe_through :api

  #  get "/song/:name", RadioController, :get_song
  #end

  # Other scopes may use custom stacks.
  # scope "/api", RadioWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:radio, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: RadioWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
