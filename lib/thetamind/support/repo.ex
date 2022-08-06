defmodule Thetamind.Repo do
  @moduledoc false
  use Ecto.Repo,
    otp_app: :thetamind,
    adapter: Ecto.Adapters.Postgres
end
