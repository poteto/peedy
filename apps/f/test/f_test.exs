defmodule Peedy.FTest do
  use ExUnit.Case
  alias Peedy.F
  alias Watermarker.Watermark

  @sample_pdf_path File.cwd! <> "/test/support/samples/pride_and_prejudice.pdf"
  @stamp_path File.cwd! <> "/test/support/samples/ricky_bobby.pdf"

  setup do
    on_exit fn -> Toniq.failed_jobs |> Enum.map(&Toniq.delete/1) end
    watermark = %Watermark{id: "tmp", input: "Ricky Bobby", output: File.read!(@stamp_path)}
    {:ok, %{watermark: watermark}}
  end

  test "perform watermarks a document", %{watermark: watermark} do
    k = fn identity -> identity end
    document = F.perform(watermark: watermark, input_path: @sample_pdf_path, ephemeral?: true, callback: k)

    assert document.input_hash  == "8013f8cf9f4d2aa9a496f36a3f1b3d28507e0970"
    assert document.output_hash == "ae48491c17597c8de63a4839eb865f68f4d97ac7"
  end
end
