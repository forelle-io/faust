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

  scope "/", FaustWeb do
    pipe_through :browser

    get "/", PageController, :index

    resources "/users", UserController
    resources "/organization", OrganizationController
    resources "/chief", ChiefController
  end
end
