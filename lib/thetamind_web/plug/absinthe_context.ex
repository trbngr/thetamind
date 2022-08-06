defmodule ThetamindWeb.Plug.AbsintheContext do
  @moduledoc false
  @behaviour Plug

  alias Plug.Conn

  def init(opts), do: opts

  def call(%Conn{private: %{user: user}} = conn, _config) do
    context = %{user: user}
    Absinthe.Plug.put_options(conn, context: context)
  end
end
