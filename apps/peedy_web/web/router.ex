defmodule PeedyWeb.Router do
  use PeedyWeb.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_session
  end

  scope "/", PeedyWeb do
    get "/healthcheck", HealthcheckController, :index
  end

  scope "/api", PeedyWeb do
    pipe_through :api

    scope "/v1", Api.V1 do
      resources "/documents", DocumentController, only: [:show, :create]
      post "/dev/null", DevNullController, :create
    end
  end
end
