defmodule Thetamind.ReadModel.NodeModel do
  use Ecto.Schema

  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: false}
  schema "nodes" do
    field :name, :string

    timestamps()
  end

  def changeset(node \\ %__MODULE__{}, attrs) do
    node
    |> cast(attrs, [:id, :name])
    |> validate_required([:id, :name])
  end
end
