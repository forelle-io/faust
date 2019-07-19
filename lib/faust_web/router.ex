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

  pipeline :basic_auth do
    plug BasicAuth,
      callback: &FaustWeb.BasicAuthPlug.authenticate/3
  end

  pipeline :maybe_authentication do
    plug FaustWeb.GuardianPipelinePlug
  end

  pipeline :ensure_not_authenticated do
    plug Guardian.Plug.EnsureNotAuthenticated, key: :user
  end

  pipeline :ensure_authentication do
    plug Guardian.Plug.EnsureAuthenticated, key: :user
    plug FaustWeb.WebsocketTokenPlug, key: :user
    plug FaustWeb.RequiredChangesetsPlug
  end

  scope "/", FaustWeb do
    env_plugs = if Mix.env() == :prod, do: [:browser, :basic_auth], else: [:browser]
    pipe_through env_plugs ++ [:maybe_authentication, :ensure_not_authenticated]

    get "/", PageController, :index

    resources "/users", UserController, only: [:new, :create]
    resources "/session", SessionController, only: [:new, :create]
  end

  scope "/", FaustWeb do
    pipe_through [:browser, :maybe_authentication, :ensure_authentication]

    delete "/session", SessionController, :delete

    resources "/users", UserController, except: [:new, :create] do
      resources "/waters", WaterController, only: [:index]
    end

    resources "/organizations", OrganizationController, only: [:index, :show]

    resources "/waters", WaterController
  end
end
