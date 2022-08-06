defmodule ThetamindWeb.Plug.UserResolution do
  @moduledoc false
  @behaviour Plug

  @impl true
  def init(opts), do: opts

  @impl true
  def call(conn, _opts) do
    user = %{id: 123, name: "developer", is_admin?: true}
    Plug.Conn.put_private(conn, :user, user)
  end
end
