defmodule Backend.Parking do
  @moduledoc """
  The Parking context.
  """

  import Ecto.Query, warn: false
  alias Backend.Repo

  alias Backend.Parking.Zone
  alias Backend.Parking.Street
  alias Backend.Parking.ParkingHouse

  @doc """
  Returns list of all zones.

  ## Examples

      iex> list_zones()
      [%Zone{}, ...]

  """
  def list_zones do
    Repo.all(Zone)
  end

  @doc """
  Returns a zone by id.

  ## Examples

      iex> get_zone_by_id(id)
      {:ok, %Zone{}}

      iex> get_zone_by_id(id)
      {:error, %Ecto.Changeset{}}

  """
  def get_zone_by_id(id) do
    case Repo.get_by(Zone, id: id) do
      nil ->
        {:error, :not_found}
      zone ->
        {:ok, zone}
    end
  end

  @doc """
  Returns list of all streets.

  ## Examples

      iex> get_streets_by()
      [%Street{}, ...]

  """
  def get_streets_by() do
    Repo.all(Street)
  end

  @doc """
  Returns list of streets based on filters.

  ## Examples

      iex> get_streets_by(filters)
      [%Street{}, ...]

  """
  def get_streets_by(filters) do
    Street
    |> where(^filters)
    |> Repo.all
  end

  @doc """
  Returns list of all parking houses.

  ## Examples

      iex> get_parking_houses_by()
      [%ParkingHouse{}, ...]

  """
  def get_parking_houses_by() do
    Repo.all(ParkingHouse)
  end

  @doc """
  Returns list of parking houses based on filters.

  ## Examples

      iex> get_parking_houses_by(filters)
      [%ParkingHouse{}, ...]

  """
  def get_parking_houses_by(filters) do
    ParkingHouse
    |> where(^filters)
    |> Repo.all
  end
end