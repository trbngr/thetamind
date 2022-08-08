defmodule Thetamind.Garden.Aggregates.Bean do
  use TypedStruct

  typedstruct enforce: true do
    field :id, String.t()
    field :name, String.t()
    field :parent_id, String.t()
    field :flagged, boolean()
  end

  alias __MODULE__
  alias Thetamind.Garden.Commands.{CreateBean, FlagBean}
  alias Thetamind.Garden.Events.{BeanCreated, BeanFlagged}

  def execute(%Bean{id: id}, %CreateBean{id: id, name: name, parent_id: parent_id}) do
    %BeanCreated{id: id, name: name, flagged: false, parent_id: parent_id}
  end

  def execute(%Bean{flagged: true}, %FlagBean{}) do
    {:error, :bean_already_flagged}
  end

  def execute(%Bean{id: id}, %FlagBean{id: id, leaf?: false}) do
    {:error, :bean_has_children}
  end

  def execute(%Bean{id: id}, %FlagBean{id: id, leaf?: true}) do
    %BeanFlagged{id: id}
  end

  def apply(%Bean{} = bean, %BeanCreated{id: id, name: name, parent_id: parent_id}) do
    %Bean{bean | id: id, name: name, parent_id: parent_id}
  end

  def apply(%Bean{} = bean, %BeanFlagged{id: _id}) do
    %Bean{bean | flagged: true}
  end
end
