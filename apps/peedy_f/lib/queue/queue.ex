defmodule PeedyF.Queue do
  require Logger
  use Toniq.Worker, max_concurrency: Application.get_env(:peedy_f, :max_concurrency)
  alias PeedyF.{Queue, Watermark, Stamper, Document}

  @doc """
  Queues the watermarking of a document with text and invokes the callback
  when complete.
  """
  @spec watermark_with(Watermark.t, callback :: (... -> any()), opts :: [input_path: String.t, ephemeral?: boolean()]) :: %{}
  def watermark_with(%Watermark{} = watermark, callback, input_path: input_path, ephemeral?: ephemeral?) when is_function(callback) do
    Toniq.enqueue(Queue,
      watermark: watermark,
      input_path: input_path,
      ephemeral?: ephemeral?,
      callback: callback)
  end
  @doc """
  Queues the watermarking of a document with text. Uses the default callback.
  """
  @spec watermark_with(Watermark.t, opts :: [input_path: String.t, ephemeral?: boolean()]) :: %{}
  def watermark_with(%Watermark{} = watermark, input_path: input_path, ephemeral?: ephemeral?) do
    Toniq.enqueue(Queue,
      watermark: watermark,
      input_path: input_path,
      ephemeral?: ephemeral?,
      callback: &default_callback/1)
  end

  def perform(watermark: watermark, input_path: input_path, ephemeral?: true, callback: callback),
    do: do_perform(watermark, input_path, true, callback)
  def perform(watermark: watermark, input_path: input_path, ephemeral?: false, callback: callback),
    do: do_perform(watermark, input_path, false, callback)

  defp do_perform(%Watermark{} = watermark, input_path, ephemeral?, callback) do
    %Document{} =
      watermark
      |> Stamper.stamp_with(input_path: input_path, ephemeral?: ephemeral?)
      |> callback.()
  end

  defp default_callback(%Document{ephemeral?: true, output_hash: output_hash}),
    do: Logger.info("Generated ephemeral document #{output_hash}")
  defp default_callback(%Document{ephemeral?: false, id: id}),
    do: Logger.info("Generated document #{id}")
end
