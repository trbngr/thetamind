defmodule Thetamind.Tasks.Protocol.DeleteNode.Handler do
  use Thetamind.Cqrs.CommandHandler

  alias Cqrs.DispatchContext
  alias Thetamind.{CommandedApp, Tasks}

  def before_dispatch(command, context) do
    with {:ok, leaf} <- get_leaf(command) do
      # This is the preferred place to enrich commands in blunt.
      # What you do with the data depends on your needs.
      #
      # If your command has an internal_field that needs to be set, use the following:
      #
      # DispatchContext.internal_field(context, :leaf, leaf)
      #
      # Otherwise, you can use the private data map in the dispatch context
      #
      # context = DispatchContext.put_private(context, :leaf, leaf)

      context = DispatchContext.internal_field(context, :leaf, leaf)
      {:ok, context}
    end
  end

  # If a command is to be simply dispatched into a commanded domain,
  # either use a handler like this or utilize pattern matching in Thetamind.Cqrs.PipelineResolver.
  #
  # Which option you choose is up to you and your needs. I tend to follow this pattern
  # as it keeps everything consistent in terms of readability.
  def handle_dispatch(%{leaf: leaf} = _command, context, _opts) do
    # Retrive private data
    # leaf = DispatchContext.get_private(context, :leaf)
    #
    # OR
    # private = DispatchContext.get_private(context)
    #
    # OR if you want all data from the command AND the private map
    # data = DispatchContext.merge_private(context)
    with {:ok, _} <- CommandedApp.dispatch_context(context) do
      leaf
    end
  end

  defp get_leaf(%{id: id}) do
    case Tasks.get_node!(id: id) do
      nil -> {:error, "node not found"}
      node -> {:ok, node}
    end
  end
end
