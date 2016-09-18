defmodule Watermarker.Strategies.HtmlTest do
  use Watermarker.Case
  alias Watermarker.Watermark
  alias Watermarker.Strategies.Html

  setup do
    jim_bob = %Watermark{input: "Jim Bob", output: <<1, 2, 3>>} |> Repo.insert!()

    {:ok, %{jim_bob: jim_bob}}
  end

  test "new: when one exists", %{jim_bob: jim_bob} do
    assert jim_bob == Html.new("Jim Bob")
  end

  test "new: when one does not exist" do
    %Watermark{} = watermark = Html.new("Ricky Bobby")
    assert watermark.input == "Ricky Bobby"
  end
end
