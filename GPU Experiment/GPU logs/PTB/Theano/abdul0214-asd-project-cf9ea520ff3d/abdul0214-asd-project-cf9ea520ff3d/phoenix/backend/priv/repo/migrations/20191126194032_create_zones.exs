defmodule Backend.Repo.Migrations.CreateZones do
  use Ecto.Migration

  def change do
    create table(:zones) do
      add :name, :string
      add :fee_hourly, :float
      add :fee_real_time, :float

      timestamps()
    end
  end
end
