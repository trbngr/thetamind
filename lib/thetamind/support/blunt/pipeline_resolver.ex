defmodule Thetamind.Cqrs.PipelineResolver do
  @behaviour Cqrs.DispatchStrategy.PipelineResolver

  @moduledoc """
  Resolves `CommandHandler`s and `QueryHandler`s by convention.

  Handler modules are meant to be named "Namespace.MessageName.Handler".
  That is, the message module with ".Handler" appended to the end.
  """

  @type pipeline_module :: atom()
  @type message_module :: atom()
  @type message_type :: atom()

  @spec resolve(message_type(), message_module()) :: {:ok, pipeline_module()} | :error

  # If this bothers you, you can start an agent and cache the lookups.
  def resolve(_message_type, message_module) do
    handler = message_module |> Module.concat(:Handler) |> to_string()
    {:ok, String.to_existing_atom(handler)}
  rescue
    _ -> :error |> IO.inspect(label: "shoud")
  end
end
