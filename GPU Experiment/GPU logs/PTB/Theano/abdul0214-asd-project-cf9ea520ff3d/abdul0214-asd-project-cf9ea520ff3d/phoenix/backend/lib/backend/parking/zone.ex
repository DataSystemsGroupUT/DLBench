defmodule Backend.Parking.Zone do
  use Ecto.Schema

  import Ecto.Changeset

  schema "zones" do
    field :name, :string
    field :fee_hourly, :float
    field :fee_real_time, :float
    has_many :streets, Backend.Parking.Street
    has_many :parking_houses, Backend.Parking.ParkingHouse
    timestamps()
  end
end