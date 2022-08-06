defmodule Thetamind.Blunt.AbsintheContextConfiguration do
  @moduledoc false
  @behaviour Blunt.Absinthe.DispatchContext.Configuration

  def configure(_message_module, %{context: context}) do
    [user: Map.get(context, :user)]
  end
end
