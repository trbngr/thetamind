defmodule Thetamind.Garden do
  import Ecto.Query, warn: false
  alias Thetamind.Repo

  alias Thetamind.CommandedApp
  alias Thetamind.Garden.Commands.CreateGarden
  alias Thetamind.Garden.Commands.CreateBean
  alias Thetamind.Garden.Commands.FlagBean
  alias Thetamind.ReadModel.BeanModel

  def create_garden(attrs, user_id) do
    id = UUID.uuid4()

    command =
      attrs
      |> CreateGarden.new()
      |> CreateGarden.assign_id(id)

    with :ok <- CommandedApp.dispatch(command, opts(user_id)) do
      get_by_id(Garden, id)
    end
  end

  def list_beans() do
    Repo.all(BeanModel)
  end

  def get_bean!(id), do: get_by_id(BeanModel, id)

  def create_bean(attrs, user_id) do
    id = UUID.uuid4()

    command =
      attrs
      |> CreateBean.new()
      |> CreateBean.assign_id(id)

    with :ok <- CommandedApp.dispatch(command, opts(user_id)) do
      get_by_id(BeanModel, id)
    end
  end

  def flag_bean(attrs, user_id) do
    command =
      attrs
      |> FlagBean.new()

    with :ok <- CommandedApp.dispatch(command, opts(user_id)) do
      get_by_id(BeanModel, command.id)
    end
  end

  defp get_by_id(schema, id) do
    case Repo.get(schema, id) do
      nil -> {:error, :not_found}
      projection -> {:ok, projection}
    end
  end

  defp opts(user_id) do
    [consistency: :strong, returning: false, metadata: %{user_id: user_id}]
  end
end
