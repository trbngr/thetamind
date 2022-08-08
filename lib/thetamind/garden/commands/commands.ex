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
    field :flagged, boolean(), default: false
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
