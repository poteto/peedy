defmodule PeedyF.Watermarker do
  require Logger
  alias PeedyF.Strategies.{Pdfkit, Erlguten}

  @after_compile __MODULE__
  @nodejs Application.get_env(:peedy_f, :executables)[:nodejs]
  @pdfkit Application.get_env(:peedy_f, :executables)[:pdfkit]

  def create(text, strategy: :pdfkit) when is_binary(text),
    do: Pdfkit.new(text)
  def create(text, strategy: :erlguten) when is_binary(text),
    do: Erlguten.new(text)
  def create(text) do
    {microseconds, watermark} = :timer.tc(fn ->
      create(text, strategy: :pdfkit)
    end)
    Logger.info("Watermark for `#{text}` generated in #{microseconds / 1_000}ms")
    watermark
  end

  def __after_compile__(_env, _bytecode) do
    if is_nil(@nodejs), do: raise error_msg("nodejs")
    if is_nil(@pdfkit), do: raise error_msg("pdfkit")
  end

  defp error_msg(missing) do
    "Missing executable for `#{missing}`. Ensure it is installed."
  end
end
