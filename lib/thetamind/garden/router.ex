defmodule Thetamind.Garden.Router do
  use Commanded.Commands.Router

  alias Thetamind.Garden.{Aggregates, Commands}

  middleware Thetamind.Middleware.EnrichCommand

  dispatch [Commands.CreateBean, Commands.FlagBean],
    to: Aggregates.Bean,
    identity: :id,
    identity_prefix: "bean-",
    lifespan: Aggregates.Bean
end
