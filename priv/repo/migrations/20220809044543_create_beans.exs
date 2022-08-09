defmodule Thetamind.Repo.Migrations.CreateBeans do
  use Ecto.Migration

  def change do
    create table(:beans) do
      add :name, :string, null: false
      add :flagged, :boolean, default: false, null: false
      add :parent_id, :uuid, null: true, references: :beans

      timestamps()
    end
  end
end
