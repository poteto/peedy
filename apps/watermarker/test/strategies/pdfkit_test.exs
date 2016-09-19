defmodule Watermarker.Strategies.PdfkitTest do
  use Watermarker.Case
  alias Watermarker.Watermark
  alias Watermarker.Strategies.Pdfkit

  setup do
    jim_bob = %Watermark{input: "Jim Bob", output: <<1, 2, 3>>} |> Repo.insert!()

    {:ok, %{jim_bob: jim_bob}}
  end

  test "new: when one exists", %{jim_bob: jim_bob} do
    assert jim_bob == Pdfkit.new("Jim Bob")
  end

  test "new: when one does not exist" do
    %Watermark{} = watermark = Pdfkit.new("Ricky Bobby")
    assert watermark.input == "Ricky Bobby"
  end
end
