defmodule Watermarker.Strategies.Pdfkit do
  @moduledoc """
  Create a watermark by using a PDFKit.
  """
  require Logger
  alias Watermarker.{Watermark,Repo}

  @behaviour Watermarker.WatermarkerBehaviour
  @nodejs Application.get_env(:watermarker, :executables)[:nodejs]
  @script_name Application.get_env(:watermarker, :executables)[:pdfkit]

  def new(text) when is_binary(text) do
    case Repo.get_by(Watermark, input: text) do
      %Watermark{} = watermark -> watermark
      nil ->
        sanitized_text = Zarex.sanitize(text)
        output_path = System.tmp_dir!() <> "#{sanitized_text}.pdf"
        output =
          text
          |> to_pdf(output_path: output_path)
          |> File.read!()

        %Watermark{}
        |> Watermark.changeset(%{input: text, output: output})
        |> Repo.insert!()
    end
  end

  def to_pdf(text, output_path: output_path) when is_binary(text) do
    File.touch!(output_path)
    %Porcelain.Result{err: nil, out: out, status: 0} = Porcelain.exec(@nodejs, [@script_name, "--text", text, "--output", output_path])
    out
  end
end
