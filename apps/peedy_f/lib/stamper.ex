defmodule PeedyF.Stamper do
  require Logger
  alias PeedyF.{Repo, Document, Watermark}

  @after_compile __MODULE__
  @pdftk Application.get_env(:peedy_f, :executables)[:pdftk]

  def stamp_with(%Watermark{id: id} = watermark, input_path: input_path, ephemeral?: true) do
    {microseconds, document} = :timer.tc(fn ->
      output_path = stamp_document(watermark, input_path)
      input = File.read!(input_path)
      output = File.read!(output_path)

      %Document{
        input: input,
        input_hash: Document.calculate_binary_hash(input),
        output: output,
        output_hash: Document.calculate_binary_hash(output),
        watermark_id: id,
        ephemeral?: true
      }
    end)
    Logger.info("Stamped #{document.id} in #{microseconds / 1_000}ms")
    document
  end
  def stamp_with(%Watermark{id: id} = watermark, input_path: input_path, ephemeral?: false) do
    {microseconds, document} = :timer.tc(fn ->
      output_path = stamp_document(watermark, input_path)

      %Document{}
      |> Document.changeset(%{
          input: File.read!(input_path),
          output: File.read!(output_path),
          watermark_id: id})
      |> Repo.insert!()
    end)
    Logger.info("Stamped #{document.id} in #{microseconds / 1_000}ms")
    document
  end

  defp stamp_path(%Watermark{id: id, output: output}) do
    stamp_path = System.tmp_dir!() <> "#{Zarex.sanitize(id)}.pdf"
    :ok = File.write!(stamp_path, output)
    stamp_path
  end

  defp random_string(length \\ 64) do
    length
    |> :crypto.strong_rand_bytes()
    |> Base.url_encode64()
    |> binary_part(0, length)
  end

  defp stamp_document(%Watermark{} = watermark, input_path) do
    output_path = System.tmp_dir!() <> "#{Zarex.sanitize(random_string())}.pdf"
    stamp_path = stamp_path(watermark)

    if File.exists?(input_path) do
      %Porcelain.Result{err: nil, out: "", status: 0} = Porcelain.exec(@pdftk, [input_path, "multistamp", stamp_path, "output", output_path])
      output_path
    else
      raise "Input at #{input_path} does not exist"
    end
  end

  def __after_compile__(_env, _bytecode) do
    if is_nil(@pdftk), do: raise error_msg("pdftk")
  end

  defp error_msg(missing) do
    "Missing executable for `#{missing}`. Ensure it is installed."
  end
end
