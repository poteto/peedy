defmodule PeedyF.Strategies.PdfkitTest do
  use PeedyF.Case
  alias PeedyF.{Strategies.Pdfkit, Watermark}

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
