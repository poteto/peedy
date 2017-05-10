defmodule PeedyF.WatermarkTest do
  use PeedyF.Case
  alias PeedyF.Watermark

  @valid_attrs %{input: "Milton Waddams", output: <<1, 2, 3>>}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Watermark.changeset(%Watermark{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Watermark.changeset(%Watermark{}, @invalid_attrs)
    refute changeset.valid?
  end
end
