defmodule Watermarker.Watermark do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @required_keys ~w(input output)a

  schema "watermarks" do
    field :input, :string
    field :output, :binary

    timestamps
  end

  def changeset(watermark, params \\ %{}) do
    watermark
    |> cast(params, @required_keys)
    |> validate_required(@required_keys)
    |> unique_constraint(:input)
  end
end
