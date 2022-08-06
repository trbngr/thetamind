defmodule Thetamind.ReadModel.Queries.ListNodes do
  use Blunt.Query

  # Just discovered that Relay connections will not work in Blunt without a field defined.
  field :name_like, :string

  binding :node, Thetamind.ReadModel.NodeModel
end
