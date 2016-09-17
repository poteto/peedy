defmodule Peedy.F do
  require Logger
  use Toniq.Worker, max_concurrency: 10
  alias Watermark.Strategies.{Html,Erlguten}

  def perform(text: text, input_path: input_path, output_path: output_path, strategy: :html) do
    text
    |> Html.new()
    |> Stamp.stamp_with(input_path: input_path, output_path: output_path)
  end
  def perform(text: text, input_path: input_path, output_path: output_path, strategy: :erlguten) do
    text
    |> Erlguten.new()
    |> Stamp.stamp_with(input_path: input_path, output_path: output_path)
  end
  def perform(_), do: :error
end
