defmodule Thetamind.ReadModel do
  use Supervisor

  alias Thetamind.ReadModel.Projectors

  def start_link(opts) do
    Supervisor.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @impl true
  def init(_) do
    children = [
      Projectors.TaskProjector
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
