defmodule Stamper.Document do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @required_keys ~w(input output stamp_id)a

  schema "documents" do
    field :input, :binary
    field :output, :binary
    field :input_hash, :string
    field :output_hash, :string
    field :stamp_id, :string

    field :ephemeral?, :boolean, virtual: true, default: false

    timestamps
  end

  def changeset(%Stamper.Document{} = document, params \\ %{}) do
    document
    |> cast(params, @required_keys)
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
  defp add_input_hash(%{valid?: true} = changeset) do
    put_change(changeset, :input_hash, calculate_binary_hash(changeset.changes.input))
  end

  defp add_output_hash(%{valid?: false} = changeset), do: changeset
  defp add_output_hash(%{valid?: true} = changeset) do
    put_change(changeset, :output_hash, calculate_binary_hash(changeset.changes.output))
  end
end
