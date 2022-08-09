# Recipe #3: https://github.com/commanded/recipes/issues/3
# Source: https://gist.github.com/slashdotdash/811d754951b2573a82ff14fe8506012e
# Source: https://github.com/trento-project/web/blob/1.0.0/lib/trento/support/middleware/enrich.ex
defmodule Thetamind.Middleware.EnrichCommand do
  @moduledoc """
  Command enrichment middleware.
  """

  @behaviour Commanded.Middleware

  alias Thetamind.Middleware.CommandEnrichment
  alias Commanded.Middleware.Pipeline

  @doc """
  Enrich the command via the opt-in command enrichment protocol.
  """
  def before_dispatch(%Pipeline{command: command} = pipeline) do
    case CommandEnrichment.enrich(command) do
      {:ok, command} ->
        %Pipeline{pipeline | command: command}

      {:error, reason} ->
        pipeline
        |> Pipeline.respond(reason)
        |> Pipeline.halt()
    end
  end

  def after_dispatch(pipeline), do: pipeline

  def after_failure(pipeline), do: pipeline
end
