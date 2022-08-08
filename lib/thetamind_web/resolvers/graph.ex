defmodule ThetamindWeb.Resolvers.Graph do
  @moduledoc false

  def aggregate_id({:ok, %{aggregate_state: %{id: id}}}), do: {:ok, id}
  def aggregate_id(other), do: other

  def fetch_node(result) do
    with {:ok, node_id} <- aggregate_id(result) do
      # FIXME: get_node(node_id) # => ** (Cqrs.InvalidValuesError) Values passed to Thetamind.ReadModel.Queries.GetNode must be either a keyword list, a map, or a struct
      # BUG: get_node(id: node_id, tag?: true) # => %NodeModel{} # tag? has no effect
      {:ok, Thetamind.Tasks.get_node!(id: node_id)}
    end
  end
end
