defmodule ThetamindWeb.Schema.TaskTypes do
  use Cqrs.Absinthe
  use Cqrs.Absinthe.Relay

  use Absinthe.Schema.Notation
  use Absinthe.Relay.Schema.Notation, :modern

  alias Thetamind.Tasks.Protocol
  alias Thetamind.ReadModel.Queries

  # derive_enum :pet_type, {Protocol.CreateNode, :pet_type}

  object :task do
    field :id, :id
    field :name, :string
  end

  # define_connection(:task, total_count: true)

  object :task_queries do
    derive_query Queries.GetNode, :task
    # derive_connection Queries.ListNodes, :task, []
  end

  object :task_mutations do
    derive_mutation Protocol.CreateNode, :task, arg_types: [pet_type: :pet_type]
  end
end
