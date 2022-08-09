defmodule Thetamind.Garden.Commands.CreateGarden do
  use TypedStruct
  use ExConstructor

  typedstruct enforce: true do
    field :id, String.t()
    field :name, String.t()
  end

  def assign_id(command, id) do
    %__MODULE__{command | id: id}
  end
end

defmodule Thetamind.Garden.Commands.CreateBean do
  use TypedStruct
  use ExConstructor

  typedstruct enforce: true do
    field :id, String.t()
    field :name, String.t()
    field :parent_id, String.t(), enforce: false
  end

  def assign_id(command, id) do
    %__MODULE__{command | id: id}
  end
end

defmodule Thetamind.Garden.Commands.FlagBean do
  use TypedStruct
  use ExConstructor

  typedstruct enforce: true do
    field :id, String.t()
    field :leaf?, boolean()
  end
end

alias Thetamind.Garden.Commands.FlagBean

defimpl Thetamind.Middleware.CommandEnrichment, for: FlagBean do
  alias Thetamind.ReadModel.BeanModel
  import Ecto.Query, only: [where: 2]

  def enrich(%FlagBean{id: id} = command) do
    # A bean is a leaf when it has no children.
    # To make flagging a subtree possible flagged nodes are not considered active children.
    query = where(BeanModel, parent_id: ^id, flagged: false)
    has_children = Thetamind.Repo.exists?(query)

    {:ok, %FlagBean{command | leaf?: not has_children}}
  end
end
