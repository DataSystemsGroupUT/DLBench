defmodule Backend.Parking.ParkingHouse do
  use Ecto.Schema

  schema "parking_houses" do
    field :description, :string
    field :coords, {:array, :float}
    field :poly_coords, {:array, {:array, :float}}
    field :total_spaces, :integer
    belongs_to :zone, Backend.Parking.Zone
    timestamps()
  end

end