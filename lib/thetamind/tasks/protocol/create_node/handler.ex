defmodule Thetamind.Tasks.Protocol.CreateNode.Handler do
  use Thetamind.Blunt.CommandHandler

  alias Thetamind.{CommandedApp, Tasks}

  # If a command is to be simply dispatched into a commanded domain,
  # either use a handler like this or utilize pattern matching in Thetamind.Blunt.PipelineResolver.
  #
  # Which option you choose is up to you and your needs. I tend to follow this pattern
  # as it keeps everything consistent in terms of readability.

  # A non-event-sourced command would simply write to the database, or whatever, here.
  def handle_dispatch(%{id: id} = _command, context, _opts) do
    with {:ok, _} <- CommandedApp.dispatch_context(context) do
      Tasks.get_node(id: id)
    end
  end
end
