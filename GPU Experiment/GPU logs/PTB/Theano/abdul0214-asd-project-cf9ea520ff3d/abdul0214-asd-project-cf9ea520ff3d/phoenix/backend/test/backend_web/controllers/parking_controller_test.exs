defmodule BackendWeb.ParkingControllerTest do
  use BackendWeb.ConnCase

  alias Backend.Repo
  alias Backend.Parking
  alias Backend.Parking.Zone
  alias Backend.Parking.Street
  alias Backend.Parking.ParkingHouse

  # TODO - could create factory for test data to be used in several places
  @zone_1 %{name: "TEST_A", fee_hourly: 2.0, fee_real_time: 0.16}
  @zone_2 %{name: "TEST_B", fee_hourly: 1.0, fee_real_time: 0.08}
  @street1_z1 %{description: "STREET_01_z_1", coords: [[1.1, 1.1], [2.2, 2.2]], total_spaces: 10}
  @street2_z1 %{description: "STREET_02_z_1", coords: [[3.3, 3.3], [4.4, 4.4]], total_spaces: 20}
  @street1_z2 %{description: "STREET_01_z_2", coords: [[5.5, 5.5], [6.6, 6.6]], total_spaces: 30}
  @street2_z2 %{description: "STREET_02_z_2", coords: [[7.7, 7.7], [8.8, 8.8]], total_spaces: 40}
  @p_house1_z1 %{description: "PHOUSE_01_z_A", coords: [1.1, 1.1], poly_coords: [[1.1, 1.1], [2.2, 2.2], [3.3, 3.3]], total_spaces: 10}
  @p_house2_z1 %{description: "PHOUSE_02_z_A", coords: [2.2, 2.2], poly_coords: [[4.4, 4.4], [5.5, 5.5], [6.6, 6.6]], total_spaces: 20}
  @p_house1_z2 %{description: "PHOUSE_01_z_B", coords: [3.3, 3.3], poly_coords: [[7.7, 7.7], [8.8, 8.8], [9.9, 9.9]], total_spaces: 30}
  @p_house2_z2 %{description: "PHOUSE_02_z_B", coords: [4.4, 4.4], poly_coords: [[10.10, 10.10], [11.11, 11.11], [12.12, 12.12]], total_spaces: 40}

  def zone_fixture(attrs \\ %{}) do
    zone = struct(Zone, attrs)
    Repo.insert!(zone)
    zone
  end

  def street_fixture(attrs, zone_id) do
    street = struct(Street, Map.put(attrs, :zone_id, zone_id))
    Repo.insert!(street)
    street
  end

  def parking_house_fixture(attrs, zone_id) do
    parking_house = struct(ParkingHouse, Map.put(attrs, :zone_id, zone_id))
    Repo.insert!(parking_house)
    parking_house
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "list zones" do
    test "zone index renders list of all zones", %{conn: conn} do
      z1 = zone_fixture(@zone_1)
      z2 = zone_fixture(@zone_2)
      [zone_a, zone_b] = Parking.list_zones()
      conn = get conn, parking_path(conn, :index_zones)

      assert json_response(conn, 200) == %{"data" => [
                                            %{
                                              "id" => zone_a.id,
                                              "name" => z1.name,
                                              "fee_hourly" => z1.fee_hourly,
                                              "fee_real_time" => z1.fee_real_time
                                            },
                                            %{
                                              "id" => zone_b.id,
                                              "name" => z2.name,
                                              "fee_hourly" => z2.fee_hourly,
                                              "fee_real_time" => z2.fee_real_time
                                            }]}
    end

    test "finding zones by id renders matching zone", %{conn: conn} do
      zone_fixture(@zone_1)
      z2 = zone_fixture(@zone_2)
      [_zone_a, zone_b] = Parking.list_zones()
      conn = get conn, parking_path(conn, :find_zone, zone_b.id)

      assert json_response(conn, 200) == %{"data" =>
                                             %{
                                               "id" => zone_b.id,
                                               "name" => z2.name,
                                               "fee_hourly" => z2.fee_hourly,
                                               "fee_real_time" => z2.fee_real_time
                                             }}
    end

    test "finding zones by invalid id renders error", %{conn: conn} do
      conn = get conn, parking_path(conn, :find_zone, -1)
      assert json_response(conn, 404) != %{}
    end
  end

  describe "list streets" do
    test "streets index renders list of all streets", %{conn: conn} do
      zone_fixture(@zone_1)
      zone_fixture(@zone_2)
      [zone_a, zone_b] = Parking.list_zones()

      street_z1 = street_fixture(@street1_z1, zone_a.id)
      street_z2 = street_fixture(@street1_z2, zone_b.id)
      [street1, street2] = Parking.get_streets_by()

      conn = get conn, parking_path(conn, :index_streets_by)

      assert json_response(conn, 200) == %{"data" => [
                                             %{
                                               "id" => street1.id,
                                               "description" => street_z1.description,
                                               "coords" => street_z1.coords,
                                               "zone_id" => street_z1.zone_id,
                                               "total_spaces" => street_z1.total_spaces
                                              },
                                             %{
                                               "id" => street2.id,
                                               "description" => street_z2.description,
                                               "coords" => street_z2.coords,
                                               "zone_id" => street_z2.zone_id,
                                               "total_spaces" => street_z2.total_spaces
                                             }]}
    end

    test "finding streets by zone_id renders list of matching streets", %{conn: conn} do
      zone_fixture(@zone_1)
      zone_fixture(@zone_2)
      [zone_a, zone_b] = Parking.list_zones()

      street_fixture(@street1_z1, zone_a.id)
      street_fixture(@street2_z1, zone_a.id)
      street1_z2 = street_fixture(@street1_z2, zone_b.id)
      street2_z2 = street_fixture(@street2_z2, zone_b.id)
      [_street11, _street12, street21, street22] = Parking.get_streets_by()

      conn = get conn, parking_path(conn, :index_streets_by, %{zone_id: zone_b.id})

      assert json_response(conn, 200) == %{"data" => [
                                             %{
                                               "id" => street21.id,
                                               "description" => street1_z2.description,
                                               "coords" => street1_z2.coords,
                                               "zone_id" => street1_z2.zone_id,
                                               "total_spaces" => street1_z2.total_spaces
                                             },
                                             %{
                                               "id" => street22.id,
                                               "description" => street2_z2.description,
                                               "coords" => street2_z2.coords,
                                               "zone_id" => street2_z2.zone_id,
                                               "total_spaces" => street2_z2.total_spaces
                                             }]}
    end

    test "finding streets by invalid zone_id renders empty list", %{conn: conn} do
      conn = get conn, parking_path(conn, :index_streets_by, %{zone_id: -1})
      assert json_response(conn, 200) == %{"data" => []}
    end

    test "finding streets by id renders matching streets", %{conn: conn} do
      zone_fixture(@zone_1)
      [zone_a] = Parking.list_zones()

      street_fixture(@street1_z1, zone_a.id)
      street_input = street_fixture(@street2_z1, zone_a.id)
      [_street1, street2] = Parking.get_streets_by()

      conn = get conn, parking_path(conn, :index_streets_by, %{id: street2.id})

      assert json_response(conn, 200) == %{"data" => [
                                             %{
                                               "id" => street2.id,
                                               "description" => street_input.description,
                                               "coords" => street_input.coords,
                                               "zone_id" => street_input.zone_id,
                                               "total_spaces" => street_input.total_spaces
                                             }]}
    end

    test "finding streets by invalid id renders empty list", %{conn: conn} do
      conn = get conn, parking_path(conn, :index_streets_by, %{id: -1})
      assert json_response(conn, 200) == %{"data" => []}
    end
  end

  describe "list parking_houses" do
    test "parking house index renders list of all parking houses", %{conn: conn} do
      zone_fixture(@zone_1)
      zone_fixture(@zone_2)
      [zone_a, zone_b] = Parking.list_zones()

      p_house_z1 = parking_house_fixture(@p_house1_z1, zone_a.id)
      p_house_z2 = parking_house_fixture(@p_house1_z2, zone_b.id)
      [p_house1, p_house2] = Parking.get_parking_houses_by()

      conn = get conn, parking_path(conn, :index_parking_houses_by)

      assert json_response(conn, 200) == %{"data" => [
                                             %{
                                               "id" => p_house1.id,
                                               "description" => p_house_z1.description,
                                               "coords" => p_house_z1.coords,
                                               "poly_coords" => p_house_z1.poly_coords,
                                               "total_spaces" => p_house_z1.total_spaces,
                                               "zone_id" => p_house_z1.zone_id
                                             },
                                             %{
                                               "id" => p_house2.id,
                                               "description" => p_house_z2.description,
                                               "coords" => p_house_z2.coords,
                                               "poly_coords" => p_house_z2.poly_coords,
                                               "total_spaces" => p_house_z2.total_spaces,
                                               "zone_id" => p_house_z2.zone_id
                                             }]}
    end

    test "finding parking houses by zone_id renders list of matching parking houses", %{conn: conn} do
      zone_fixture(@zone_1)
      zone_fixture(@zone_2)
      [zone_a, zone_b] = Parking.list_zones()

      parking_house_fixture(@p_house1_z1, zone_a.id)
      parking_house_fixture(@p_house2_z1, zone_a.id)
      p_house1_z2 = parking_house_fixture(@p_house1_z2, zone_b.id)
      p_house2_z2 = parking_house_fixture(@p_house2_z2, zone_b.id)
      [_p_house11, _p_house12, p_house21, p_house22] = Parking.get_parking_houses_by()

      conn = get conn, parking_path(conn, :index_parking_houses_by, %{zone_id: zone_b.id})

      assert json_response(conn, 200) == %{"data" => [
                                             %{
                                               "id" => p_house21.id,
                                               "description" => p_house1_z2.description,
                                               "coords" => p_house1_z2.coords,
                                               "poly_coords" => p_house1_z2.poly_coords,
                                               "total_spaces" => p_house1_z2.total_spaces,
                                               "zone_id" => p_house1_z2.zone_id
                                             },
                                             %{
                                               "id" => p_house22.id,
                                               "description" => p_house2_z2.description,
                                               "coords" => p_house2_z2.coords,
                                               "poly_coords" => p_house2_z2.poly_coords,
                                               "total_spaces" => p_house2_z2.total_spaces,
                                               "zone_id" => p_house2_z2.zone_id
                                             }]}
    end

    test "finding parking houses by id renders matching parking houses", %{conn: conn} do
      zone_fixture(@zone_1)
      [zone_a] = Parking.list_zones()

      parking_house_fixture(@p_house1_z1, zone_a.id)
      p_house_input = parking_house_fixture(@p_house2_z1, zone_a.id)
      [_p_house1, p_house2] = Parking.get_parking_houses_by()

      conn = get conn, parking_path(conn, :index_parking_houses_by, %{id: p_house2.id})

      assert json_response(conn, 200) == %{"data" => [
                                             %{
                                               "id" => p_house2.id,
                                               "description" => p_house_input.description,
                                               "coords" => p_house_input.coords,
                                               "poly_coords" => p_house_input.poly_coords,
                                               "zone_id" => p_house_input.zone_id,
                                               "total_spaces" => p_house_input.total_spaces
                                             }]}
    end

    test "finding parking houses by invalid params renders empty list", %{conn: conn} do
      conn = get conn, parking_path(conn, :index_parking_houses_by, %{zone_id: -1})
      assert json_response(conn, 200) == %{"data" => []}

      conn = get conn, parking_path(conn, :index_parking_houses_by, %{id: -1})
      assert json_response(conn, 200) == %{"data" => []}
    end
  end
end