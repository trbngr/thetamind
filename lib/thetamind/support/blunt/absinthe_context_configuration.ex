defmodule Thetamind.Cqrs.AbsintheContextConfiguration do
  @moduledoc false
  @behaviour Cqrs.Absinthe.DispatchContext.Configuration

  def configure(_message_module, %{context: context}) do
    [user: Map.get(context, :user), scope?: true, authorize?: true]
  end
end
