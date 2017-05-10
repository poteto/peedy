defmodule PeedyF.DocumentTest do
  use PeedyF.Case
  alias PeedyF.{Watermark, Document}

  @watermark_id Ecto.UUID.generate()

  setup do
    watermark = %Watermark{id: @watermark_id, input: "Jim Bob", output: <<1, 2>>}
    |> Repo.insert!()

    {:ok, %{watermark: watermark}}
  end

  @valid_attrs %{input: <<1, 2, 3>>, output: <<4, 5, 6>>, watermark_id: @watermark_id}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Document.changeset(%Document{}, @valid_attrs)
    assert changeset.valid?
    refute changeset.changes.input_hash == nil
  end

  test "changeset with invalid attributes" do
    changeset = Document.changeset(%Document{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "calculate_binary_hash generates stable sha1 hash for binary" do
    assert Document.calculate_binary_hash(<<1, 2>>) == "0ca623e2855f2c75c842ad302fe820e41b4d197d"
    assert Document.calculate_binary_hash("hey")    == "7f550a9f4c44173a37664d938f1355f0f92a47a7"
  end
end
