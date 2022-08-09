defmodule Thetamind.Garden.Bean do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "beans" do
    field :flagged, :boolean, default: false
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(bean, attrs) do
    bean
    |> cast(attrs, [:name, :flagged])
    |> validate_required([:name, :flagged])
  end
end
