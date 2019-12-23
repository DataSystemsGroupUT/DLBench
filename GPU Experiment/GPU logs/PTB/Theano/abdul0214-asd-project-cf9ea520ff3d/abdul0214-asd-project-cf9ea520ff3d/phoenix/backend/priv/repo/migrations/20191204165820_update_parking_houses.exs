defmodule Backend.Repo.Migrations.UpdateParkingHouses do
  use Ecto.Migration

  def change do
    alter table(:parking_houses) do
      add :total_spaces, :integer
    end
  end
end
