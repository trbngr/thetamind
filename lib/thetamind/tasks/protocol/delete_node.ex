defmodule Thetamind.Tasks.Protocol.DeleteNode do
  use Blunt.Command
  use Blunt.Command.EventDerivation

  field :id, :binary_id

  internal_field :leaf, :map

  derive_event NodeDeleted
end
