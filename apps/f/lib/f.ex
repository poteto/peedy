defmodule Peedy.F do
  require Logger
  use Toniq.Worker, max_concurrency: Application.get_env(:f, :max_concurrency)
  alias Stamper.Document

  @doc """
  Queues the watermarking of a document with text and invokes the callback
  when complete.
  """
  @spec watermark(text :: String.t, callback :: (... -> any()), opts :: [input_path: String.t, ephemeral?: boolean()]) :: %{}
  def watermark(text, callback, input_path: input_path, ephemeral?: ephemeral?) when is_binary(text) and is_function(callback) do
    Toniq.enqueue(Peedy.F,
      text: text,
      input_path: input_path,
      ephemeral?: ephemeral?,
      callback: callback)
  end
  @doc """
  Queues the watermarking of a document with text. Uses the default callback.
  """
  @spec watermark(text :: String.t, opts :: [input_path: String.t, ephemeral?: boolean()]) :: %{}
  def watermark(text, input_path: input_path, ephemeral?: ephemeral?) when is_binary(text) do
    Toniq.enqueue(Peedy.F,
      text: text,
      input_path: input_path,
      ephemeral?: ephemeral?,
      callback: &default_callback/1)
  end

  def perform(watermarker \\ Watermarker, _)
  def perform(watermarker, text: text, input_path: input_path, ephemeral?: true, callback: callback),
    do: do_perform(watermarker, text, input_path, true, callback)
  def perform(watermarker, text: text, input_path: input_path, ephemeral?: false, callback: callback),
    do: do_perform(watermarker, text, input_path, false, callback)

  defp do_perform(watermarker, text, input_path, ephemeral?, callback) do
    %Document{} =
      text
      |> watermarker.create()
      |> Stamper.stamp_with(input_path: input_path, ephemeral?: ephemeral?)
      |> callback.()
  end

  defp default_callback(%Document{ephemeral?: true, output_hash: output_hash}),
    do: Logger.info("Generated ephemeral document #{output_hash}")
  defp default_callback(%Document{ephemeral?: false, id: id}),
    do: Logger.info("Generated document #{id}")
end
