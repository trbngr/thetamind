defmodule Thetamind.ReadModel.Projectors.TaskProjector do
  use Commanded.Event.Handler,
    application: Thetamind.CommandedApp,
    name: to_string(__MODULE__) <> "-v1",
    consistency: :strong

  alias Thetamind.{Repo, Tasks}
  alias Thetamind.Tasks.Protocol
  alias Thetamind.ReadModel.NodeModel

  def handle(%Protocol.NodeCreated{} = event, _metadata) do
    event
    |> Map.from_struct()
    |> NodeModel.changeset()
    |> Repo.insert!()

    :ok
  end

  def handle(%Protocol.NodeDeleted{id: id}, _metadata) do
    %{id: id}
    |> Tasks.get_node!()
    |> Repo.delete!()

    :ok
  end
end
