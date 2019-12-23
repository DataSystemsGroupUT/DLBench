defmodule BackendWeb.Router do
  use BackendWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug CORSPlug, origin: ["http://localhost:8080", "https://localhost:8080"]
    plug :accepts, ["json"]
  end

  scope "/", BackendWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  scope "/api", BackendWeb do
    pipe_through :api
    post "/users/signup", UserController, :create
    options "/users/signup", UserController, :create
    post "/users/signin", UserController, :signin
    options "/users/signin", UserController, :signin

    get "/parking/zones", ParkingController, :index_zones
    options "/parking/zones", ParkingController, :index_zones
    get "/parking/zones/:id", ParkingController, :find_zone
    options "/parking/zones/:id", ParkingController, :find_zone

    get "/parking/streets", ParkingController, :index_streets_by
    options "/parking/streets", ParkingController, :index_streets_by

    get "/parking/parking_houses", ParkingController, :index_parking_houses_by
    options "/parking/parking_houses", ParkingController, :index_parking_houses_by
  end

  # Other scopes may use custom stacks.
  # scope "/api", BackendWeb do
  #   pipe_through :api
  # end
end
