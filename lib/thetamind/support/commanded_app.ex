defmodule Thetamind.CommandedApp do
  use Commanded.Application,
    otp_app: :thetamind,
    default_dispatch_opts: [
      consistency: :strong,
      returning: :execution_result
    ]

  router Thetamind.Tasks.Router

  defdelegate dispatch_context(context, metadata \\ %{}), to: Thetamind.Blunt.Commanded, as: :dispatch
end
