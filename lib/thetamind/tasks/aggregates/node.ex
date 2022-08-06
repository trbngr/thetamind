defmodule Thetamind.Tasks.Aggregates.Node do
  defstruct [:id]

  alias Thetamind.Tasks.Protocol.{CreateNode, NodeCreated}
  alias Thetamind.Tasks.Protocol.{DeleteNode, NodeDeleted}

  def execute(%{id: nil}, %CreateNode{} = command), do: NodeCreated.new(command)
  def execute(_state, %CreateNode{}), do: nil

  # Nothing get's past here with an ID
  def execute(%{id: nil}, _command), do: {:error, "node not found"}

  def execute(_state, %DeleteNode{} = command), do: NodeDeleted.new(command)

  def apply(state, %NodeCreated{id: id}), do: %{state | id: id}
  def apply(state, %NodeDeleted{}), do: %{state | id: nil}

  @behaviour Commanded.Aggregates.AggregateLifespan
  def after_error(_), do: :timer.seconds(1)
  def after_event(_), do: :timer.minutes(15)
  def after_command(_), do: :timer.minutes(15)
end
