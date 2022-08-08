defmodule Thetamind.ReadModel.Projectors.BeanProjector do
  use Commanded.Event.Handler,
    application: Thetamind.CommandedApp,
    name: to_string(__MODULE__) <> "-v1",
    consistency: :strong

  alias Thetamind.{Repo, Tasks}
  alias Thetamind.Garden.Events
  alias Thetamind.ReadModel.BeanModel

  def handle(%Events.BeanCreated{} = event, _metadata) do
    event
    |> Map.from_struct()
    |> BeanModel.changeset()
    |> Repo.insert!()

    :ok
  end

  def handle(%Events.BeanFlagged{id: id}, _metadata) do
    %{id: id}
    |> Garden.get_bean!()
    |> BeanModel.changeset(flagged: true)
    |> Repo.update!()

    :ok
  end
end
