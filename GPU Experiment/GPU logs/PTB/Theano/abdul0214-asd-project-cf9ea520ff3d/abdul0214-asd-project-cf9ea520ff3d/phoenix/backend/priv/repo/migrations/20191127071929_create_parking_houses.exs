defmodule Backend.Repo.Migrations.CreateParkingHouses do
  use Ecto.Migration

  def change do

  end
end
defmodule Backend.Repo.Migrations.CreateParkingHouses do
  use Ecto.Migration

  #TODO - potential to create a coordinate type
  def change do
    create table(:parking_houses) do
      add :zone_id, references(:zones)
      add :description, :string
      add :coords, {:array, :float}
      add :poly_coords, {:array, {:array, :float}}
      timestamps()
    end
  end
end