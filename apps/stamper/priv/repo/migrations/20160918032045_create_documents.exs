defmodule Stamper.Repo.Migrations.CreateDocuments do
  use Ecto.Migration

  def change do
    create table(:documents, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :input, :binary
      add :input_hash, :string
      add :output, :binary
      add :stamp_id, :string

      timestamps
    end
  end
end
