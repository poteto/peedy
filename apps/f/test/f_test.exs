defmodule Peedy.FTest do
  use ExUnit.Case
  alias Peedy.F
  alias Watermarker.Watermark

  @sample_pdf_path File.cwd! <> "/test/support/samples/pride_and_prejudice.pdf"

  defmodule DummyWatermarker do
    @stamp_path File.cwd! <> "/test/support/samples/ricky_bobby.pdf"

    def create(text) do
      %Watermark{id: "tmp", input: text, output: File.read!(@stamp_path)}
    end
  end

  test "perform watermarks a document" do
    k = fn identity -> identity end
    document = F.perform(DummyWatermarker, text: "Ricky Bobby", input_path: @sample_pdf_path, ephemeral?: true, callback: k)

    assert document.input_hash  == "8013f8cf9f4d2aa9a496f36a3f1b3d28507e0970"
    assert document.output_hash == "ae48491c17597c8de63a4839eb865f68f4d97ac7"
  end
end
