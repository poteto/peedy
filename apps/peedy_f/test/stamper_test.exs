defmodule PeedyF.StamperTest do
  use PeedyF.Case
  alias PeedyF
  alias PeedyF.{Repo, Document, Watermark, Stamper}

  @sample_pdf_path File.cwd! <> "/test/support/samples/pride_and_prejudice.pdf"
  @stamp_path File.cwd! <> "/test/support/samples/ricky_bobby.pdf"
  @watermark_id Ecto.UUID.generate()

  setup do
    watermark = %Watermark{id: @watermark_id, input: "Jim Bob", output: File.read!(@stamp_path)}
      |> Repo.insert!()

    {:ok, %{watermark: watermark}}
  end

  test "stamp_with: when ephemeral", %{watermark: watermark} do
    %Document{} = document = Stamper.stamp_with(watermark, input_path: @sample_pdf_path, ephemeral?: true)

    assert is_binary(document.input)
    assert is_binary(document.output)
    assert document.watermark_id == @watermark_id
    assert document.ephemeral?
    assert length(Repo.all(Document)) == 0
  end

  test "stamp_with: when persisted", %{watermark: watermark} do
    %Document{} = document = Stamper.stamp_with(watermark, input_path: @sample_pdf_path, ephemeral?: false)

    assert is_binary(document.input)
    assert is_binary(document.output)
    assert document.watermark_id == @watermark_id
    refute document.ephemeral?
    assert length(Repo.all(Document)) == 1
  end
end
