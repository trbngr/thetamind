defmodule Thetamind.Garden.Events.GardenCreated do
  use TypedStruct
  @derive [Jason.Encoder]

  typedstruct enforce: true do
    field :id, String.t()
    field :name, String.t()
  end
end

defmodule Thetamind.Garden.Events.BeanCreated do
  use TypedStruct
  @derive [Jason.Encoder]

  typedstruct enforce: true do
    field :id, String.t()
    field :name, String.t()
    field :flagged, boolean()
    field :parent_id, String.t(), enforce: false
  end
end

defmodule Thetamind.Garden.Events.BeanFlagged do
  use TypedStruct
  @derive [Jason.Encoder]

  typedstruct enforce: true do
    field :id, String.t()
  end
end
