defmodule PeedyF.Repo.Migrations.CreateWatermarks do
  use Ecto.Migration

  def change do
    create table(:watermarks, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :input, :string
      add :output, :binary

      timestamps
    end
  end
end
