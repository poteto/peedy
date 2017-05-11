defmodule PeedyF.Repo.Migrations.CreateDocuments do
  use Ecto.Migration

  def change do
    create table(:documents, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :input, :binary
      add :input_hash, :string
      add :output, :binary
      add :watermark_id, references(:watermarks, type: :uuid)

      timestamps
    end
  end
end
