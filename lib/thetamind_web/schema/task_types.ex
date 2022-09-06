defmodule ThetamindWeb.Schema.TaskTypes do
  use Blunt.Absinthe
  use Blunt.Absinthe.Relay

  use Absinthe.Schema.Notation
  use Absinthe.Relay.Schema.Notation, :modern

  alias Thetamind.Tasks.Protocol
  alias Thetamind.ReadModel.Queries

  derive_enum :pet_type, {Protocol.CreateNode, :pet_type}

  object :task do
    field :id, :id
    field :name, :string
    field :icon, :icon
  end

  object :icon do
    field :key, :string
    field :value, :string
  end

  define_connection(:task, total_count: true)

  object :task_queries do
    derive_query Queries.GetNode, :task
    derive_connection Queries.ListNodes, :task, []

    field :get_node_with_icon, :task do
      arg :id, :id

      resolve(fn _, %{id: id}, _ ->
        alias Thetamind.ReadModel.NodeModel

        Thetamind.Repo.get(NodeModel, id)
      end)
    end
  end

  object :task_mutations do
    derive_mutation Protocol.CreateNode, :task, except: [:icon], arg_types: [pet_type: :pet_type, icon: :icon_input]

    # derive_mutation Protocol.CreateNode, :task,
    #   as: :create_node_with_icon,
    #   except: [:pet_type],
    #   arg_types: [pet_type: :pet_type, icon: :icon_input]

    field :create_node_with_icon, :task do
      arg :name, non_null(:string)
      arg :icon, :icon_input

      resolve(fn _, args, _ ->
        {:ok, command} = Thetamind.Tasks.Protocol.CreateNode.new(args)

        with {:ok, aggregate} <-
               Thetamind.CommandedApp.dispatch(command, returning: :aggregate_state, consistency: :strong) do
          node = Thetamind.Repo.get(Thetamind.ReadModel.NodeModel, aggregate.id)
          {:ok, node}
        end
      end)
    end
  end

  input_object :icon_input do
    field :key, :string
    field :value, :string
  end
end
