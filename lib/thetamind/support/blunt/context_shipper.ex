defmodule Thetamind.Cqrs.ContextShipper do
  @moduledoc false

  @behaviour Cqrs.DispatchContext.Shipper

  require Logger

  def ship(%{errors: [], message_module: message} = context) do
    Logger.debug("#{inspect(message)}", context: context)
  end

  def ship(%{message_module: message} = context) do
    Logger.error("#{inspect(message)} had errors", context: context)
  end
end
