defmodule Thetamind.Repo.Migrations.Initial do
  use Ecto.Migration

  def change do
    create table(:nodes) do
      add :name, :string
      add :icon, :map
      timestamps()
    end
  end
end
