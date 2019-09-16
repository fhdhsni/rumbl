defmodule RumblWeb.Router do
  use RumblWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug RumblWeb.Auth
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/" do
    pipe_through :browser

    get "/", RumblWeb.PageController, :index
    resources "/users", RumblWeb.UserController, only: [:index, :show, :new, :create]
    resources("/sessions", RumblWeb.SessionController, only: [:new, :create, :delete])
  end

  scope "/manage" do
    pipe_through [:browser, :authenticate_user]
    resources "/videos", RumblWeb.VideoController
  end

  # Other scopes may use custom stacks.
  # scope "/api", RumblWeb do
  #   pipe_through :api
  # end
end
