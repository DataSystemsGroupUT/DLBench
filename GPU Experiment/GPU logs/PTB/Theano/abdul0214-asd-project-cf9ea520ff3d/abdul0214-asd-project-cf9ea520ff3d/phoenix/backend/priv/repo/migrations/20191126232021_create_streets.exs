defmodule Backend.Repo.Migrations.CreateStreets do
  use Ecto.Migration

  #TODO - potential to create a coordinate type
  def change do
    create table(:streets) do
      add :zone_id, references(:zones)
      add :description, :string
      add :coords, {:array, {:array, :float}}
      timestamps()
    end
  end
end
