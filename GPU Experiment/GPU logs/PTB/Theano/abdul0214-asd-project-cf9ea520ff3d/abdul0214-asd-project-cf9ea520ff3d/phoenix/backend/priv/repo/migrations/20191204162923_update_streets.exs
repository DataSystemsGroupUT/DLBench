defmodule Backend.Repo.Migrations.UpdateStreets do
  use Ecto.Migration

  def change do
    alter table(:streets) do
      add :total_spaces, :integer
    end
  end
end
