defmodule PeedyF.Repo.Migrations.AddOutputHashToDocuments do
  use Ecto.Migration

  def change do
    alter table(:documents) do
      add :output_hash, :string
    end
  end
end
