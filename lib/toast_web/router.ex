defmodule ToastWeb.Router do
  use ToastWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Toast.Services.ToastPipe
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ToastWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/ind", PageController, :ind
  end

  #   Other scopes may use custom stacks.
  scope "/api", ToastWeb.Api do
    pipe_through :api

    get "/test", GeneralController, :test
    post "/ussd", UssdController, :at_sms
  end
end
