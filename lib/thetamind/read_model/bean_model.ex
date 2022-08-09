defmodule Thetamind.ReadModel.BeanModel do
  use Ecto.Schema

  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: false}
  schema "beans" do
    field :name, :string
    field :flagged, :boolean
    field :parent_id, :binary_id

    timestamps()
  end

  def changeset(node \\ %__MODULE__{}, attrs) do
    node
    |> cast(attrs, [:id, :name, :flagged, :parent_id])
    |> validate_required([:id, :name, :flagged])
  end
end
