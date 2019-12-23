defmodule BackendWeb.ParkingController do
  use BackendWeb, :controller

  alias Backend.Parking
  alias Backend.Parking.Zone
  alias Backend.Parking.Street
  alias Backend.Parking.ParkingHouse

  action_fallback BackendWeb.FallbackController

  def index_zones(conn, params) do
    render conn, "zones.json", zones: Parking.list_zones()
  end

  def find_zone(conn, %{"id" => id}) do
    with { :ok, result } <- Parking.get_zone_by_id(id) do
      render conn, "zone.json", zone: result
    end
  end

  def index_streets_by(conn, params) do
    filters = Ecto.Changeset.cast(%Street{}, params, [:id, :zone_id]) |> Map.fetch!(:changes) |> Map.to_list
    render conn, "streets.json", streets: Parking.get_streets_by(filters)
  end

  def index_parking_houses_by(conn, params) do
    filters = Ecto.Changeset.cast(%ParkingHouse{}, params, [:id, :zone_id]) |> Map.fetch!(:changes) |> Map.to_list
    render conn, "parking_houses.json", parking_houses: Parking.get_parking_houses_by(filters)
  end


end

