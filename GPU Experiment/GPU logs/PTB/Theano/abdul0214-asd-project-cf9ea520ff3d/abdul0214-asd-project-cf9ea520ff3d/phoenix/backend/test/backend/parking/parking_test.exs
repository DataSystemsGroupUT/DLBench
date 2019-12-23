defmodule Backend.ParkingTest do

  use Backend.DataCase

  alias Backend.Parking
  alias Backend.Parking.Zone
  alias Backend.Parking.Street
  alias Backend.Parking.ParkingHouse

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

  describe "zones" do

    test "list_zones/0 returns all zones" do
      z1 = zone_fixture(@zone_1)
      z2 = zone_fixture(@zone_2)
      [zone_a, zone_b] = Parking.list_zones()

      assert zone_a.name == z1.name
      assert zone_a.fee_hourly == z1.fee_hourly
      assert zone_a.fee_real_time == z1.fee_real_time

      assert zone_b.name == z2.name
      assert zone_b.fee_hourly == z2.fee_hourly
      assert zone_b.fee_real_time == z2.fee_real_time
    end

    test "get_zone_by_id/1 returns zone by id" do
      zone_fixture(@zone_1)
      zone_fixture(@zone_2)
      [zone_a, _zone_b] = Parking.list_zones()

      assert {:ok, %Zone{} = zone_a_by_id} = Parking.get_zone_by_id(zone_a.id)

      assert zone_a_by_id.name == zone_a.name
      assert zone_a_by_id.fee_hourly == zone_a.fee_hourly
      assert zone_a_by_id.fee_real_time == zone_a.fee_real_time
    end
  end

  describe "streets" do
    test "get_streets_by/0 returns all streets" do
      zone_fixture(@zone_1)
      zone_fixture(@zone_2)
      [zone_a, zone_b] = Parking.list_zones()

      street_z1 = street_fixture(@street1_z1, zone_a.id)
      street_z2 = street_fixture(@street1_z2, zone_b.id)

      [street1, street2] = Parking.get_streets_by()

      assert street1.zone_id == zone_a.id
      assert street1.description == street_z1.description
      assert street1.coords == street_z1.coords
      assert street1.total_spaces == street_z1.total_spaces

      assert street2.zone_id == zone_b.id
      assert street2.description == street_z2.description
      assert street2.coords == street_z2.coords
      assert street2.total_spaces == street_z2.total_spaces
    end

    test "get_streets_by/1 returns all streets matching filter with zone_id" do
      zone_fixture(@zone_1)
      zone_fixture(@zone_2)
      [zone_a, zone_b] = Parking.list_zones()

      street_fixture(@street1_z1, zone_a.id)
      street_fixture(@street2_z1, zone_a.id)
      street1_z2 = street_fixture(@street1_z2, zone_b.id)
      street2_z2 = street_fixture(@street2_z2, zone_b.id)

      [street21, street22] = Parking.get_streets_by([zone_id: zone_b.id])

      assert street21.zone_id == zone_b.id
      assert street21.description == street1_z2.description
      assert street21.coords == street1_z2.coords
      assert street21.total_spaces == street1_z2.total_spaces

      assert street22.zone_id == zone_b.id
      assert street22.description == street2_z2.description
      assert street22.coords == street2_z2.coords
      assert street22.total_spaces == street2_z2.total_spaces
    end

    test "get_street_by_id/1 returns all streets matching filter with id" do
      zone_fixture(@zone_1)
      [zone_a] = Parking.list_zones()

      street_fixture(@street1_z1, zone_a.id)
      street_fixture(@street2_z1, zone_a.id)
      [street1, _street2] = Parking.get_streets_by()

      [result_street_1] = Parking.get_streets_by([id: street1.id])

      assert result_street_1 == street1
    end
  end

  describe "parking_houses" do
    test "get_parking_houses_by/0 returns all parking houses" do
      zone_fixture(@zone_1)
      zone_fixture(@zone_2)
      [zone_a, zone_b] = Parking.list_zones()

      parking_house_z1 = parking_house_fixture(@p_house1_z1, zone_a.id)
      parking_house_z2 = parking_house_fixture(@p_house2_z2, zone_b.id)

      [p_house1, p_house2] = Parking.get_parking_houses_by()

      assert p_house1.zone_id == zone_a.id
      assert p_house1.description == parking_house_z1.description
      assert p_house1.coords == parking_house_z1.coords
      assert p_house1.poly_coords == parking_house_z1.poly_coords
      assert p_house1.total_spaces == parking_house_z1.total_spaces

      assert p_house2.zone_id == zone_b.id
      assert p_house2.description == parking_house_z2.description
      assert p_house2.coords == parking_house_z2.coords
      assert p_house2.poly_coords == parking_house_z2.poly_coords
      assert p_house2.total_spaces == parking_house_z2.total_spaces
    end
  end

  test "get_parking_houses_by/1 returns all parking_houses with specified zone_id" do
    zone_fixture(@zone_1)
    zone_fixture(@zone_2)
    [zone_a, zone_b] = Parking.list_zones()

    parking_house_fixture(@p_house1_z1, zone_a.id)
    parking_house_fixture(@p_house2_z1, zone_a.id)
    p_house1_z2 = parking_house_fixture(@p_house1_z2, zone_b.id)
    p_house2_z2 = parking_house_fixture(@p_house2_z2, zone_b.id)

    [p_house21, p_house22] = Parking.get_parking_houses_by([zone_id: zone_b.id])

    assert p_house21.zone_id == zone_b.id
    assert p_house21.description == p_house1_z2.description
    assert p_house21.coords == p_house1_z2.coords
    assert p_house21.poly_coords == p_house1_z2.poly_coords
    assert p_house21.total_spaces == p_house1_z2.total_spaces

    assert p_house22.zone_id == zone_b.id
    assert p_house22.description == p_house2_z2.description
    assert p_house22.coords == p_house2_z2.coords
    assert p_house22.poly_coords == p_house2_z2.poly_coords
    assert p_house22.total_spaces == p_house2_z2.total_spaces
  end

end