defmodule Thetamind.Tasks.Protocol.DeleteNode do
  use Blunt.Command
  use Blunt.Command.EventDerivation

  field :id, :binary_id

  internal_field :leaf, :map

  # Change this as needed for your needs. See authorize_command/2 in support/blunt/dispatch_strategy/command_strategy
  metadata :auth,
    user_roles: :all,
    account_types: :all

  derive_event NodeDeleted
end
