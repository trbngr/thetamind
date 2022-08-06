defmodule ThetamindWeb.Router do
  use ThetamindWeb, :router

  pipeline :api do
    plug Plug.Logger, log: :debug
    plug :accepts, ["json"]
    plug :fetch_session
    plug :put_secure_browser_headers
    plug ThetamindWeb.Plug.UserResolution
    plug ThetamindWeb.Plug.AbsintheContext
  end

  scope "/api" do
    pipe_through :api
    forward "/", Absinthe.Plug, schema: ThetamindWeb.Schema
  end

  forward "/graphiql", ThetamindWeb.Plug.GraphiQL
end
