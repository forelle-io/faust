defmodule FaustWeb.Router do
  use FaustWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :maybe_authentication do
    plug FaustWeb.GuardianPipelinePlug
  end

  pipeline :without_authentication do
    plug FaustWeb.WithoutAuthenticationPlug, key: :user
  end

  pipeline :ensure_authentication do
    plug Guardian.Plug.EnsureAuthenticated, key: :user
  end

  scope "/", FaustWeb do
    pipe_through [:browser, :maybe_authentication, :without_authentication]

    get "/", PageController, :index

    resources "/users", UserController, only: [:new, :create]
    resources "/session", SessionController, only: [:new, :create]
  end

  scope "/", FaustWeb do
    pipe_through [:browser, :maybe_authentication, :ensure_authentication]

    resources "/users", UserController, except: [:new, :create]
    resources "/organization", OrganizationController
    resources "/chief", ChiefController

    delete "/session", SessionController, :delete
  end
end
