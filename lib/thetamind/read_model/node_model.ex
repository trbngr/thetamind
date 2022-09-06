defmodule Thetamind.ReadModel.NodeModel do
  use Ecto.Schema
  alias __MODULE__

  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: false}
  schema "nodes" do
    field :name, :string
    embeds_one :icon, NodeModel.Icon, on_replace: :update

    timestamps()
  end

  def changeset(node \\ %__MODULE__{}, attrs) do
    node
    |> cast(attrs, [:id, :name])
    |> cast_embed(:icon, with: &icon_changeset/2)
    |> validate_required([:id, :name])
  end

  def icon_changeset(icon, attrs \\ %{}) do
    icon
    |> cast(attrs, [:key, :value])
    |> validate_required([:key, :value])
  end

  defmodule Icon do
    use Ecto.Schema

    embedded_schema do
      field(:key, Ecto.Enum, values: [:emoji, :image])
      field(:value, :string)
    end
  end
end
