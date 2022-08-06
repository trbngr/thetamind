defmodule ThetamindWeb.Plug.GraphiQL do
  use Plug.Router
  # import Plug.BasicAuth

  plug :match
  # plug :basic_auth, username: "admin", password: "admin"
  plug :dispatch

  get "/" do
    path =
      :thetamind
      |> Application.app_dir("priv/static")
      |> Path.join("graphiql.html")

    conn
    |> put_resp_header("content-type", "text/html; charset=utf-8")
    |> send_file(200, path)
  end
end
