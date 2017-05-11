defmodule PeedyF.Repo.Migrations.AddUniqueIndexToWatermarks do
  use Ecto.Migration

  def change do
    create unique_index(:watermarks, [:input])
  end
end
