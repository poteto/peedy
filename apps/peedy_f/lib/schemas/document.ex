defmodule PeedyF.Document do
  use Ecto.Schema
  import Ecto.Changeset
  alias PeedyF.{Document, Watermark}

  @primary_key {:id, :binary_id, autogenerate: true}
  @required_keys ~w(input output watermark_id)a

  schema "documents" do
    field :input, :binary
    field :output, :binary
    field :input_hash, :string
    field :output_hash, :string
    belongs_to :watermark, Watermark, type: Ecto.UUID

    field :ephemeral?, :boolean, virtual: true, default: false

    timestamps()
  end

  def changeset(%Document{} = document, params \\ %{}) do
    document
    |> cast(params, @required_keys)
    |> foreign_key_constraint(:watermark_id)
    |> validate_required(@required_keys)
    |> add_input_hash()
    |> add_output_hash()
  end

  def calculate_binary_hash(input) when is_binary(input) do
    :sha
    |> :crypto.hash(input)
    |> Base.encode16()
    |> String.downcase()
  end

  defp add_input_hash(%{valid?: false} = changeset), do: changeset
  defp add_input_hash(%{valid?: true, changes: changes} = changeset) do
    put_change(changeset, :input_hash, calculate_binary_hash(changes.input))
  end

  defp add_output_hash(%{valid?: false} = changeset), do: changeset
  defp add_output_hash(%{valid?: true, changes: changes} = changeset) do
    put_change(changeset, :output_hash, calculate_binary_hash(changes.output))
  end
end
