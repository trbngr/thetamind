defmodule Thetamind.Tasks do
  use Blunt.BoundedContext

  alias Thetamind.ReadModel.Queries

  query Queries.GetNode
  query Queries.GetNode, as: :node_exists, exists?: true
end
