defmodule BackendWeb.ParkingView do
  use BackendWeb, :view

  def render("zones.json", %{zones: zones}) do
    %{
      data: Enum.map(zones, &zone_json/1)
    }
  end

  def render("zone.json", %{zone: zone}) do
    %{
      data: zone_json(zone)
    }
  end

  def zone_json(zone) do
    %{
      id: zone.id,
      name: zone.name,
      fee_hourly: zone.fee_hourly,
      fee_real_time: zone.fee_real_time
    }
  end

  def render("streets.json", %{streets: streets}) do
    %{
      data: Enum.map(streets, &street_json/1)
    }
  end

#  def render("street.json", %{street: street}) do
#    %{
#      data: street_json(street)
#    }
#  end

  def street_json(street) do
    %{
      id: street.id,
      description: street.description,
      coords: street.coords,
      zone_id: street.zone_id,
      total_spaces: street.total_spaces
    }
  end

  def render("parking_houses.json", %{parking_houses: parking_houses}) do
    %{
      data: Enum.map(parking_houses, &parking_house_json/1)
    }
  end

  def parking_house_json(parking_house) do
    %{
      id: parking_house.id,
      description: parking_house.description,
      coords: parking_house.coords,
      poly_coords: parking_house.poly_coords,
      total_spaces: parking_house.total_spaces,
      zone_id: parking_house.zone_id
    }
  end
end