defmodule Stamper.StamperTest do
  use Stamper.Case
  alias Stamper
  alias Stamper.{Repo,Document}
  alias Watermarker.Watermark

  @sample_pdf_path File.cwd! <> "/test/support/samples/pride_and_prejudice.pdf"
  @stamp_path File.cwd! <> "/test/support/samples/ricky_bobby.pdf"

  setup do
    watermark = %Watermark{id: "tmp", input: "Jim Bob", output: File.read!(@stamp_path)}

    {:ok, %{watermark: watermark}}
  end

  test "stamp_with: when ephemeral", %{watermark: watermark} do
    %Document{} = document = Stamper.stamp_with(watermark, input_path: @sample_pdf_path, ephemeral?: true)

    assert is_binary(document.input)
    assert is_binary(document.output)
    assert document.stamp_id == "tmp"
    assert document.ephemeral?
    assert length(Repo.all(Document)) == 0
  end

  test "stamp_with: when persisted", %{watermark: watermark} do
    %Document{} = document = Stamper.stamp_with(watermark, input_path: @sample_pdf_path, ephemeral?: false)

    assert is_binary(document.input)
    assert is_binary(document.output)
    assert document.stamp_id == "tmp"
    refute document.ephemeral?
    assert length(Repo.all(Document)) == 1
  end
end
