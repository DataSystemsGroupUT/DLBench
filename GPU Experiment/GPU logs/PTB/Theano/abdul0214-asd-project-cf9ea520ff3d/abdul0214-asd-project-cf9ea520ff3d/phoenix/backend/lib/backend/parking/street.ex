defmodule Backend.Parking.Street do
  use Ecto.Schema

  schema "streets" do
    field :description, :string
    field :coords, {:array, {:array, :float}}
    field :total_spaces, :integer
    belongs_to :zone, Backend.Parking.Zone
    timestamps()
  end

end