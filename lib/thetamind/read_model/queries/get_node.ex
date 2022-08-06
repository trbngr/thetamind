defmodule Thetamind.ReadModel.Queries.GetNode do
  use Blunt.Query

  field :id, :binary_id
  field :name, :string

  require_at_least_one [:id, :name]

  option :exists?, :boolean, default: false

  binding :node, Thetamind.ReadModel.NodeModel
end
