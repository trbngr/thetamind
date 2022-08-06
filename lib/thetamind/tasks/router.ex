defmodule Thetamind.Tasks.Router do
  use Commanded.Commands.Router

  alias Thetamind.Tasks.{Aggregates, Protocol}

  dispatch [Protocol.CreateNode, Protocol.DeleteNode],
    to: Aggregates.Node,
    identity: :id,
    identity_prefix: "node-",
    lifespan: Aggregates.Node
end
